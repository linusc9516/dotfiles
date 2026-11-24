<!-- dsh-only layer. dsh also loads the shared core from ~/.agents/AGENTS.md, so never copy core rules here. -->

## Tool calls: emit them correctly, recover in one line

A malformed tool call is a generation slip, not a planning error. No instruction
can prevent one, because the slip happens while the call is being written. What
these rules control is the cost, which is entirely in the recovery.

**The failure mode.** A parameter block gets written by hand and a parameter name
is invented or a tool is misnamed: `name`/`file_path` sent to `bash`, a `command`
and `description` pair sent to `read`, a `read` call emitted with the `write`
argument shape. The result is a dead call that does nothing. Nothing was changed;
nothing is broken.

**Recovery, in strict order:**

1. Re-emit the same call once, with the correct parameter names. Change nothing
   about the intent.
2. If it fails again, the shape is wrong, not the spelling. Stop and re-read the
   tool's own parameter list before the third attempt.
3. Never narrate the slip beyond one short line. "Tool call was malformed,
   re-issuing." is the whole response.
4. Never treat a dead call as evidence about the file. A call that never ran
   proves nothing about whether an edit landed.

**The expensive part is the loop, not the slip.** After any dead call, do not:

- re-read a file that a *successful* edit or write in this session already
  changed, to check whether it landed;
- re-run a verification command that already passed;
- reproduce a measurement with a second, differently-written probe.

One successful read or write is authoritative. Trust it and move on.

**Write calls in the plainest available shape.** Use the fewest parameters that
do the job, copy the parameter names exactly from the tool definition, and never
build a call out of remembered fragments. If a call is long or repetitive, that
is the moment to slow down: slips cluster in long tool-heavy stretches.

**When an edit reports "file changed since it was read",** re-read the file, then
retry the edit. That is the observation policy working, not a bug. Do not reach
for `write` to bypass it.

## dsh reply voice

The caveman rule that binds in dsh is the `personaPrefix` in the dsh profile patch (`~/.dsh/profiles/desktop/cordis.patch.yml`), a reserved prompt section above this file. Keep it in sync with Communication in the core (`~/.agents/AGENTS.md`); on any conflict, the persona prefix wins.
