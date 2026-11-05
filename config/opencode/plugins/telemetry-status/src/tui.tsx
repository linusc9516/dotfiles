/** @jsxImportSource @opentui/solid */
import { Plugin } from "@opencode/plugin/tui"
import { createRoot } from "solid-js"
import { execFileSync } from "node:child_process"
import { readFileSync, statSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

const SNAPSHOT = join(homedir(), ".local/state/opencode/telemetry.json")
const HOME = homedir()

// Catppuccin Mocha. Hardcoded because semantic theme tokens did not resolve
// through this renderer's runtime shim; literal hex does work.
const MOCHA = {
  base: "#cdd6f4",
  muted: "#6c7086",
  overlay: "#7f849c",
  green: "#a6e3a1",
  yellow: "#f9e2af",
  red: "#f38ba8",
  blue: "#89b4fa",
  mauve: "#cba6f7",
  teal: "#94e2d5",
  pink: "#f5c2e7",
}

// Rendering happens often, so the snapshot is re-parsed only when its mtime
// changes and the git branch is recomputed at most once a minute.
let cache = { mtime: 0, data: null }
let branchCache = { at: 0, dir: null, value: null }

function read() {
  try {
    const st = statSync(SNAPSHOT)
    if (st.mtimeMs === cache.mtime && cache.data) return cache.data
    const data = JSON.parse(readFileSync(SNAPSHOT, "utf8"))
    cache = { mtime: st.mtimeMs, data }
    return data
  } catch {
    return cache.data ?? null
  }
}

function fmt(n) {
  return n >= 10 ? n.toFixed(1) : n.toFixed(2)
}

function shortPath(dir) {
  if (!dir) return null
  return dir.startsWith(HOME) ? "~" + dir.slice(HOME.length) : dir
}

function gitBranch(dir) {
  const now = Date.now()
  if (branchCache.dir === dir && now - branchCache.at < 60_000) return branchCache.value
  let value = null
  try {
    value =
      execFileSync("git", ["branch", "--show-current"], {
        cwd: dir,
        encoding: "utf8",
        timeout: 2000,
        stdio: ["ignore", "pipe", "ignore"],
      }).trim() || null
  } catch {
    value = null
  }
  branchCache = { at: now, dir, value }
  return value
}

// Green at >=95%, yellow 85-95%, red below.
function hitTone(pct) {
  if (pct >= 95) return MOCHA.green
  if (pct >= 85) return MOCHA.yellow
  return MOCHA.red
}

// Rolling spend against a monthly budget. A 7-day window scaled by 30/7 gives
// the monthly projection: $5 -> ~$21.4/mo, $8 -> ~$34.3/mo.
function spendTone(week) {
  if (week > 8) return MOCHA.red
  if (week > 5) return MOCHA.yellow
  return MOCHA.overlay
}

function build(sessionID) {
  const s = read()
  if (!s) return []

  const parts = []
  const cwd = process.cwd()

  const dir = shortPath(cwd)
  if (dir) parts.push({ text: dir, fg: MOCHA.teal })

  const branch = gitBranch(cwd)
  if (branch) parts.push({ text: branch, fg: MOCHA.mauve })

  // Prefer the session this footer is rendering. The slot passes its ID; when
  // it is absent or unknown, fall back to the most recently active session.
  const sess =
    (sessionID && s.sessions?.[sessionID]) ?? s.session ?? null

  // Context from this session's latest step, falling back to the global last
  // step for sessions the map has not seen yet.
  const ctxTokens = sess?.lastPromptTokens ?? s.last?.promptTokens
  const ctxPct = sess?.lastContextPct ?? s.last?.contextUsedPct
  if (typeof ctxTokens === "number" && ctxTokens > 0) {
    const size =
      ctxTokens >= 1e6 ? (ctxTokens / 1e6).toFixed(2) + "M" : (ctxTokens / 1e3).toFixed(1) + "k"
    parts.push({
      text: typeof ctxPct === "number" ? `${size} (${ctxPct.toFixed(0)}%)` : size,
      fg: MOCHA.base,
    })
  }

  const hit = sess?.cacheHitPct
  if (typeof hit === "number") parts.push({ text: `hit ${hit.toFixed(1)}%`, fg: hitTone(hit) })

  // Only flag the most recent step, not the session's running miss count.
  if (typeof sess?.lastCacheHitPct === "number" && sess.lastCacheHitPct === 0) {
    parts.push({ text: "miss", fg: MOCHA.red })
  }

  const tps = sess?.tokensPerSecondAvg
  if (typeof tps === "number" && tps > 0) {
    parts.push({ text: `${tps.toFixed(1)} t/s`, fg: MOCHA.pink })
  }

  if (s.spend) {
    parts.push({ text: `$${fmt(s.spend.today)}`, fg: MOCHA.blue })
    parts.push({ text: `${s.spend.days}d $${fmt(s.spend.week)}`, fg: spendTone(s.spend.week) })
  }

  return parts
}

export default Plugin.define({
  id: "user.telemetryStatus",
  setup(context: any) {
    return createRoot((dispose) => {
      if (!context?.ui?.slot) return dispose

      context.ui.slot({
        replace: "prompt.footer",
        render: (input: any) => {
          const parts = build(input?.sessionID)
          if (!parts.length) return null
          return (
            <box flexDirection="row" width="100%" justifyContent="flex-end" flexShrink={1} minWidth={0}>
              {parts.map((part, i) => (
                <text wrapMode="none" fg={part.fg}>
                  {part.text}
                  {i < parts.length - 1 ? " · " : ""}
                </text>
              ))}
            </box>
          )
        },
      })

      return dispose
    })
  },
})
