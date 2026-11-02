import { appendFileSync, mkdirSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

const DIR = join(homedir(), ".local/state/opencode")
const LOG = join(DIR, "deepinfra-telemetry.log")
const DEBUG = process.env.DI_TELEMETRY_DEBUG === "1"
// promo $/token: cached 0.003/1M, uncached 0.10/1M, output 0.29/1M
const RATE = { cached: 3e-9, uncached: 1e-7, out: 2.9e-7 }

const seen = new Set()
const session = new Map()

function write(line) {
  try {
    mkdirSync(DIR, { recursive: true })
    appendFileSync(LOG, line + "\n")
  } catch {}
}

// normalize two possible shapes to { cached, uncached, out }
function normalize(info) {
  const t = info?.tokens
  if (t) {
    const cached = t.cache?.read ?? 0
    const written = t.cache?.write ?? 0
    return { cached, uncached: (t.input ?? 0) + written, out: (t.output ?? 0) + (t.reasoning ?? 0) }
  }
  const u = info?.usage
  if (u) {
    const prompt = u.prompt_tokens ?? 0
    const cached = u.prompt_tokens_details?.cached_tokens ?? 0
    return { cached, uncached: Math.max(0, prompt - cached), out: u.completion_tokens ?? 0 }
  }
  return null
}

function handle(event) {
  const p = event?.properties ?? event?.data ?? event ?? {}
  const info = p.info ?? p
  if (DEBUG) write(`[debug] ${event?.type} ${JSON.stringify(event).slice(0, 1500)}`)

  if (info?.role && info.role !== "assistant") return
  const done = info?.finish || info?.time?.completed || info?.usage
  if (!done) return
  const id = info.id ?? p.messageID
  if (id && seen.has(id)) return
  const n = normalize(info)
  if (!n || n.cached + n.uncached + n.out === 0) return
  if (id) seen.add(id)

  const prompt = n.cached + n.uncached
  const hit = prompt ? ((n.cached / prompt) * 100).toFixed(1) : "0.0"
  const cost = n.cached * RATE.cached + n.uncached * RATE.uncached + n.out * RATE.out

  const sid = info.sessionID ?? p.sessionID ?? "?"
  const s = session.get(sid) ?? { cached: 0, uncached: 0, out: 0, cost: 0 }
  s.cached += n.cached; s.uncached += n.uncached; s.out += n.out; s.cost += cost
  session.set(sid, s)
  const sPrompt = s.cached + s.uncached
  const sHit = sPrompt ? ((s.cached / sPrompt) * 100).toFixed(1) : "0.0"

  write(
    `${new Date().toISOString().slice(11, 19)} ` +
    `hit ${hit}% (${n.cached.toLocaleString()}/${prompt.toLocaleString()}) ` +
    `out ${n.out.toLocaleString()} cost $${cost.toFixed(5)} | ` +
    `session hit ${sHit}% cost $${s.cost.toFixed(4)}`
  )
}

export default {
  id: "user.deepinfra-telemetry",
  async setup(ctx) {
    const reg = await ctx.event.subscribe((event) => {
      try { handle(event) } catch (e) { write(`[error] ${e?.message}`) }
    })
    return () => {
      if (typeof reg === "function") reg()
      else reg?.dispose?.()
    }
  },
}
