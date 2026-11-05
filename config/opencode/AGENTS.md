## Environment
- macOS (BSD tools: `sed -i ''`, no GNU flags). fish shell. nvim.
- Fish syntax in all shell commands. `set -x`, not `export`. No bash heredocs.
- Python 3. `uv` only: `uv init`, `uv add`, `uv run`, `uvx` for one-off tools. Never `pip` or `venv`.
- Python style: type hints, `uvx ruff check` and `uvx ruff format`.

## Tool Roles
- Search content: `rg`. Find files: `fd`. Never `grep` or `find`.
- Git read-only (`status`, `diff`, `log`) free. Commit only when asked.
- Library docs: `context7` first. No guessing APIs from memory.
- Web search: current facts only. One line announcing need first.
- Bash output already filtered by RTK. Do not add `head` or `tail` to cut it.
- Bulk read of large files: delegate to small model if available.

## Ambiguity
- If anything conflicts — instructions, files, conventions, prior decisions — STOP and ask.
- NEVER implicitly assume my intent. If a request could be read two ways, ask which.
- Ask the fewest questions needed to remove the ambiguity. One is fine.
- Before writing to an existing file or note that is not covered by a documented convention, confirm the target.
- Exception: only when I explicitly say "use your judgement", "just do it", or "pick one".

## Context Files
- `~/Chat` is the working directory for misc, non-coding quicklaunch sessions. It is not a project root.
- Sessions start with an unknown scope and may grow into coursework, system customisation, research, or similar. Do not assume a session is throwaway.
- Do not keep a single global `decisions.md` there. Create `~/Chat/<task-slug>/` per session, and set it as the session directory.
- Creating directories under `~/Chat` is pre-authorised. Every other operation there still needs permission.
- Each session dir gets two files:
  - `decisions.md` — append-only: rejected approaches with reasons, plus invariants. Never rewritten, never reordered.
  - `handoff.md` — overwritten at each task boundary: goal, state, files touched, next action, open questions.
- Global, cross-project rules belong in this file, not in any `decisions.md`.
- Delete the session directory once the task is done.

### When to propose a session directory
Proactively suggest creating `~/Chat/<task-slug>/` when any of these is true:
- A non-obvious approach was rejected, or an invariant was established that a fresh session would otherwise re-litigate.
- Work now spans multiple files, machines, or sessions.
- The task has shifted from the original request into a distinct one.
- A decision was adopted that the user may want to revisit or undo later.

Suggest once per session, at the moment the threshold is crossed. Do not re-suggest after a refusal unless the scope changes materially.

Proposal format, kept to a few lines:
- Proposed directory name, in kebab-case.
- Which files: `decisions.md`, `handoff.md`, or both, and why.
- What would go in each, one line.

Creating the directory still requires explicit approval. Never create, write, or move the session without a yes. `~/Chat` itself is pre-authorised for directory creation only; nothing else there is.

## Vault

`~/obsidian-vault/TODO.md` and `~/obsidian-vault/vault.md` are readable without asking; every other path there needs an explicit yes. No vault writes unless the user says "follow vault.md" — all vault write rules live there, not here.

## Personal Data

**Never commit personal data.** This is a hard rule, not a default. Before any `git add`, `git commit`, or `git push`, check what is being staged against this list:

- Voice profiles, writing samples, and style guides
- `memory.md` and any persistent memory or profile file
- Identity material: real name, address, phone, date of birth, NRIC/ID numbers
- Contact details and account handles not already public
- Academic records, grades, transcripts, and assessment feedback
- Application material: cover letters, CVs, interview notes, scholarship and internship applications
- Communications: emails, messages, calendar contents, DMs
- Health, financial, and subscription information
- Anything under a path already treated as private, such as `agents/linkedin/`, `~/.local`, or a secrets file

The list is illustrative, not exhaustive. The test is whether the content is *about* the user rather than *for a tool*. If a file could be published without identifying or exposing the user, it is fine. If it describes them, their history, or their private work, it is not.

**If anything resembles the above, stop and ask before acting.** Do not decide it is harmless because it looks anodyne, already public elsewhere, or only loosely related. Do not commit it, stage it, or move it into a tracked path on the assumption that the user will notice. Ask first, with the path and what it contains.

This applies to history rewrites too. Removing personal data from history does not un-disclose it, so the question is asked before the commit is made, not after.

## Workflow
- Read file before editing. Grep for existing pattern before writing new.
- Verify TODO checkboxes against the filesystem before reporting them done; a ticked box is a claim, not evidence. Do not re-litigate `[x]` items.
- Small diffs. One change per step.
- Ask before: delete, `sudo`, new dependency, touching `.env*`, writing outside project.
- Verify before saying done: run tests, type check, or build. Report result. Not run = say so.
- Unsure = ask one question. Do not guess.
- Use a skill only when its description matches. Do not load all.

## Academic
- User is Y1 CS student, NTU.
- Graded work (assignment, quiz, lab): hints and bug checks only. No full solution.
- Practice or study: full worked answer OK.
- Explain reasoning from first principles on request.

## Communication
- Chat: caveman speak. Short. Answer first. No fluff.
- Paths, commands, code blocks: exact.
- Code, comments, docs, commit messages: standard English.
