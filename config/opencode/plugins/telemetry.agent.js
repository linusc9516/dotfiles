import { appendFileSync, mkdirSync, readFileSync, writeFileSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"
import { execFileSync } from "node:child_process"

const DIR = join(homedir(), ".local/state/opencode")
const LOG = join(DIR, "telemetry.log")
const SNAPSHOT = join(DIR, "telemetry.json")
const DEBUG = process.env.OC_TELEMETRY_DEBUG === "1"

// Wafer billed spend. The usage API returns cost in USD per UTC day bucket;
// `input_tokens` includes cache reads. There is no balance endpoint, so spend
// since `starting_at` is the only figure available.
const WAFER_USAGE = "https://api.wafer.ai/v1/usage"
const SPEND_WINDOW_DAYS = 7
const SPEND_FLOOR_MS = 60 * 60 * 1000

// Fallback context limits (tokens), keyed by model ID, for providers whose
// models OpenCode does not resolve a `limit` for.
const CONTEXT_LIMITS = {
  "DeepSeek-V4.1-Flash-1017": 1048576,
  "DeepSeek-V4.1-Flash": 1048576,
  "DeepSeek-V4-Flash-0731-Fast": 1048576,
  "GLM-5.3": 1048576,
}

// Per-session totals, keyed by sessionID.
const sessions = new Map()
// Step dispatch time, keyed by assistant message ID. `session.step.started`
// carries `started` (epoch ms, request dispatch). `session.step.ended` has no
// end timestamp, so completion time is measured on arrival.
const steps = new Map()
// Step IDs already counted. Module-scoped so every setup() call shares it: the
// background service and a standalone run can each hold a live subscription,
// and the same step can otherwise be counted more than once.
const handled = new Set()

let lastSpendAt = 0
// Last successful spend pull, mirrored into the snapshot for the TUI plugin.
let lastSpend = null

function ensure() {
  try {
    mkdirSync(DIR, { recursive: true })
  } catch {}
}

function log(line) {
  try {
    ensure()
    appendFileSync(LOG, line + "\n")
  } catch {}
}

function num(x) {
  return typeof x === "number" && Number.isFinite(x) ? x : 0
}

// TokenUsage.Info = { input, output, reasoning, cache: { read, write } }.
// `input` is the NON-cached prompt portion (OpenCode normalizes providers to
// this), `cache.read` is the cached portion, and `output` excludes reasoning.
// Prompt size and cache hit rate therefore need all three summed.
function split(t) {
  const uncached = num(t?.input)
  const cached = num(t?.cache?.read)
  const written = num(t?.cache?.write)
  const reasoning = num(t?.reasoning)
  return {
    prompt: uncached + cached,
    cached,
    uncached: uncached + written,
    out: num(t?.output) + reasoning,
    reasoning,
  }
}

function pct(part, whole) {
  return whole ? ((part / whole) * 100).toFixed(1) : "0.0"
}

function compact(n) {
  if (n >= 1e6) return (n / 1e6).toFixed(2) + "M"
  if (n >= 1e3) return (n / 1e3).toFixed(1) + "k"
  return String(n)
}

function state(id) {
  let s = sessions.get(id)
  if (!s) {
    s = { prompt: 0, cached: 0, out: 0, steps: 0, misses: 0, elapsedMs: 0, lastCached: 0, lastPrompt: 0, model: null, agent: null }
    sessions.set(id, s)
  }
  return s
}

// Read the Wafer key from the macOS Keychain. The shell exports WAFER_API_KEY,
// but that variable was absent in the process that ran compaction and caused
// 401s, so it is not relied on here.
function waferKey() {
  try {
    return execFileSync(
      "security",
      ["find-generic-password", "-a", process.env.USER ?? "", "-s", "wafer-api-key", "-w"],
      { encoding: "utf8", timeout: 5000, stdio: ["ignore", "pipe", "ignore"] },
    ).trim()
  } catch {
    return null
  }
}

function utcDay(d) {
  return d.toISOString().slice(0, 10)
}

// Returns { today, week, days } where `week` covers the rolling window
// including today. Auth failures and network errors return null.
async function fetchSpend() {
  const key = waferKey()
  if (!key) return null
  const start = new Date()
  start.setUTCDate(start.getUTCDate() - (SPEND_WINDOW_DAYS - 1))
  const url = `${WAFER_USAGE}?starting_at=${utcDay(start)}&bucket_width=1d`
  const ac = new AbortController()
  const timer = setTimeout(() => ac.abort(), 10000)
  try {
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${key}` },
      signal: ac.signal,
    })
    if (!res.ok) return null
    const body = await res.json()
    const data = Array.isArray(body?.data) ? body.data : []
    const last = data[data.length - 1]
    return {
      today: num(last?.cost_usd),
      week: num(body?.totals?.cost_usd),
      days: data.length,
    }
  } catch {
    return null
  } finally {
    clearTimeout(timer)
  }
}

async function logSpend(force = false) {
  const now = Date.now()
  if (!force && now - lastSpendAt < SPEND_FLOOR_MS) return
  lastSpendAt = now
  const s = await fetchSpend()
  if (!s) {
    log(`${new Date().toISOString().slice(11, 19)} [spend] unavailable`)
    return
  }
  lastSpend = { today: s.today, week: s.week, days: s.days, at: new Date().toISOString() }
  mirrorSnapshot()
  log(
    `${new Date().toISOString().slice(11, 19)} spend ~${s.days}d $${s.week.toFixed(4)} ` +
      `today $${s.today.toFixed(4)}`,
  )
}

// Rewrite the snapshot's `spend` block without disturbing step data, so the
// TUI plugin sees spend changes between steps.
function mirrorSnapshot() {
  try {
    ensure()
    const raw = readFileSync(SNAPSHOT, "utf8")
    const snap = JSON.parse(raw)
    snap.spend = lastSpend
    writeFileSync(SNAPSHOT, JSON.stringify(snap, null, 2))
  } catch {}
}

function handle(event, limits) {
  const type = event?.type
  // Plugin stream uses `data`; the HTTP SSE envelope uses `properties`.
  const d = event?.data ?? event?.properties ?? {}
  const sid = d.sessionID ?? "?"

  if (type === "session.step.started") {
    // Measure from arrival, not from `started`: the field is the request
    // dispatch time and lags several hundred ms behind the event.
    steps.set(d.assistantMessageID, {
      at: Date.now(),
      model: d.model ?? null,
      agent: d.agent ?? null,
    })
    return
  }

  if (type !== "session.step.ended") return

  // Count each step once, whichever subscription delivered it.
  const stepID = d.assistantMessageID
  if (stepID) {
    if (handled.has(stepID)) return
    handled.add(stepID)
    if (handled.size > 5000) {
      // Bound the set; oldest entries go first (Set preserves insertion order).
      const it = handled.values()
      for (let i = 0; i < 2500; i++) handled.delete(it.next().value)
    }
  }

  const t = split(d.tokens)
  if (t.prompt + t.out === 0) return

  const start = steps.get(d.assistantMessageID)
  steps.delete(d.assistantMessageID)

  const modelKey = start?.model ? `${start.model.providerID}/${start.model.id}` : null

  const elapsedMs = start ? Math.max(0, Date.now() - start.at) : 0
  const tps = elapsedMs > 0 ? t.out / (elapsedMs / 1000) : 0

  // Context occupancy is the prompt size for this step against the model's limit.
  const ctxLimit = (modelKey ? num(limits.get(modelKey)) : 0) || num(CONTEXT_LIMITS[start?.model?.id])
  const ctxPct = ctxLimit ? ((t.prompt / ctxLimit) * 100).toFixed(1) : "?"

  const s = state(sid)
  s.prompt += t.prompt
  s.cached += t.cached
  s.out += t.out
  s.steps += 1
  s.elapsedMs += elapsedMs
  if (t.cached === 0 && t.prompt > 0) s.misses += 1
  // Latest step only, so the footer reports whether this turn missed the
  // cache rather than a running session total.
  s.lastCached = t.cached
  s.lastPrompt = t.prompt
  s.lastContextPct = ctxLimit ? Number(ctxPct) : null
  if (start?.model) s.model = start.model

  log(
    `${new Date().toISOString().slice(11, 19)} ` +
      `in ${compact(t.prompt)}${ctxLimit ? `/ctx ${ctxPct}%` : ""} (hit ${pct(t.cached, t.prompt)}%) ` +
      `unc ${compact(t.uncached)}` +
      (t.cached === 0 ? " MISS" : "") +
      ` out ${compact(t.out)}` +
      (t.reasoning ? ` (reason ${compact(t.reasoning)})` : "") +
      ` ${tps ? tps.toFixed(1) + " tok/s" : "-"} | ` +
      `session ${s.steps} steps in ${compact(s.prompt)} out ${compact(s.out)} ` +
      `hit ${pct(s.cached, s.prompt)}%` +
      (s.misses ? ` misses ${s.misses}` : "") +
      (start?.model ? ` [${start.model.providerID}/${start.model.id}]` : ""),
  )

  try {
    ensure()
    writeFileSync(
      SNAPSHOT,
      JSON.stringify(
        {
          updatedAt: new Date().toISOString(),
          last: {
            model: start?.model ?? null,
            agent: start?.agent ?? null,
            seconds: Number((elapsedMs / 1000).toFixed(2)),
            tokensPerSecond: Number(tps.toFixed(1)),
            promptTokens: t.prompt,
            cachedTokens: t.cached,
            uncachedTokens: t.uncached,
            outputTokens: t.out,
            reasoningTokens: t.reasoning,
            cacheHitPct: Number(pct(t.cached, t.prompt)),
            contextLimit: ctxLimit || null,
            contextUsedPct: ctxLimit ? Number(ctxPct) : null,
            finish: d.finish ?? null,
          },
          session: {
            sessionID: sid,
            model: s.model,
            steps: s.steps,
            promptTokens: s.prompt,
            cachedTokens: s.cached,
            outputTokens: s.out,
            cacheHitPct: Number(pct(s.cached, s.prompt)),
            cacheMisses: s.misses,
            tokensPerSecondAvg: s.elapsedMs > 0 ? Number((s.out / (s.elapsedMs / 1000)).toFixed(1)) : 0,
          },
          sessions: sessionSnapshot(),
          spend: lastSpend,
        },
        null,
        2,
      ),
    )
  } catch (e) {
    log(`[error] snapshot ${e?.message}`)
  }
}

// Serialize the per-session map so the footer can look up the session it is
// rendering rather than whichever session ran most recently. Bounded so a long
// day of sessions does not grow the file without limit.
const MAX_SESSION_SNAPSHOTS = 20

function sessionSnapshot() {
  const out = {}
  const ids = [...sessions.keys()]
  const keep = ids.slice(-MAX_SESSION_SNAPSHOTS)
  for (const id of keep) {
    const s = sessions.get(id)
    if (!s) continue
    out[id] = {
      sessionID: id,
      model: s.model,
      steps: s.steps,
      promptTokens: s.prompt,
      cachedTokens: s.cached,
      outputTokens: s.out,
      cacheHitPct: Number(pct(s.cached, s.prompt)),
      cacheMisses: s.misses,
      lastPromptTokens: s.lastPrompt,
      lastCacheHitPct: Number(pct(s.lastCached, s.lastPrompt)),
      lastContextPct: s.lastContextPct ?? null,
      tokensPerSecondAvg: s.elapsedMs > 0 ? Number((s.out / (s.elapsedMs / 1000)).toFixed(1)) : 0,
    }
  }
  return out
}

export default {
  id: "user.telemetry",
  async setup(ctx) {
    // Dedupe guard: the background service and a standalone run can both hold a
    // live subscription, and OpenCode may deliver the same step event more than
    // once. Module-scoped so it is shared by every setup() call.
    // providerID/modelID -> context limit, read once at startup.
    const limits = new Map()
    try {
      const models = await ctx.model.list()
      const arr = Array.isArray(models)
        ? models
        : models?.data ?? models?.models ?? (typeof models === "object" ? Object.values(models) : [])
      for (const m of [].concat(...arr).flat()) {
        if (m?.limit?.context) {
          // Provider IDs differ between the model list and events (e.g. `wafer.ai` vs `wafer`).
          limits.set(`${m.providerID}/${m.id}`, m.limit.context)
          limits.set(`${String(m.providerID).replace(/\.ai$/, "")}/${m.id}`, m.limit.context)
        }
      }
      if (DEBUG) log(`[limits] ${limits.size} models: ${[...limits.keys()].join(", ")}`)
    } catch (e) {
      log(`[limits] ${e?.message}`)
    }

    const ac = new AbortController()
    ;(async () => {
      try {
        const stream = await ctx.event.subscribe({
          types: ["session.step.started", "session.step.ended", "session.idle"],
          signal: ac.signal,
        })
        for await (const event of stream) {
          if (DEBUG) log(`[debug] ${event?.type} sid=${event?.data?.sessionID} msg=${event?.data?.assistantMessageID} ${JSON.stringify(event).slice(0, 3000)}`)
          try {
            if (event?.type === "session.idle") {
              logSpend().catch(() => {})
              continue
            }
            handle(event, limits)
          } catch (e) {
            log(`[error] ${e?.message}`)
          }
        }
      } catch (e) {
        if (e?.name !== "AbortError") log(`[subscribe] ${e?.message}`)
      }
    })()

    // One pull at startup so the log opens with current spend.
    logSpend(true).catch(() => {})

    return () => ac.abort()
  },
}
