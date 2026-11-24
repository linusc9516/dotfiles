# Global agent instructions

Shared by every coding agent (Claude Code, OpenCode, Codex, dsh). A rule belongs here only if it holds in every tool; tool-specific rules (shell syntax, output filters, tool-call quirks) live in that tool's layer file. Project files (`AGENTS.md`, `CLAUDE.md`) override this file.

## Communication
- **Caveman is the default voice, in every session.** Load the `caveman` skill at the first reply of a new session, before answering, and follow it thereafter. Do not wait to be asked.
- Plain prose only for the four exceptions the skill defines: security warning, irreversible action, step order a fragment could scramble, user confused or repeating.
- Short questions stay caveman ("Which image?"). Use prose for a question only when a fragment would be misread.
- Paths, commands, code blocks: exact.
- Content written outside chat is never caveman: code, comments, docs, commit messages, issues, PRs, memory files and third-party messages are standard English.
- "stop caveman" or "normal mode" switches it off for the session; a new session starts in caveman again.

## Ambiguity
- If anything conflicts — instructions, files, conventions, prior decisions — STOP and ask.
- NEVER implicitly assume my intent. If a request could be read two ways, ask which.
- Ask the fewest questions needed to remove the ambiguity. One is fine.
- Minor, reversible implementation choices (a name, a flag, a file layout inside the task): pick a sensible default and say which in one line. Ask only for real forks.
- Before writing to an existing file or note that is not covered by a documented convention, confirm the target. The edit rules under Workflow count as a documented convention.
- Exception: when I explicitly say "use your judgement", "just do it", or "pick one", decide.

## Environment
- macOS: BSD tools (`sed -i ''`, no GNU flags). nvim.
- Shell syntax depends on the tool; see its layer file.

## Tools
- Prefer `rg` to search content and `fd` to find files. A tool's own search tools are fine.
- Git read-only (`status`, `diff`, `log`) is free. Commit or push only when asked.
- Library docs: `context7` first when it is available. No guessing APIs from memory.
- Web search: current facts only. One line announcing the need first.
- Bulk reads of large files: delegate to a smaller model if the tool offers one.
- Use a skill only when its description matches. Do not load all.

## Python
- `uv` only. Never `pip` or a hand-made `venv`.
- Projects: `uv init`, `uv add`, `uv sync`; run anything that imports the project (tests, type checkers, scripts) with `uv run`, inside the project's `.venv`.
- Standalone tools that do not import the project: `uvx` (for example `uvx ruff check`, `uvx ruff format`). A project's own file may pin a version and say `uv run ruff` instead; follow it.
- If console scripts fail with "No such file or directory" after a repo is moved or renamed, rebuild with `rm -rf .venv && uv sync`.
- Type hints on all function signatures.
- Before calling work done, run the project's tests and linter.

## Code comments
- Default to no comment. Code shows *how*; comment only to carry *why* — a non-obvious constraint, deliberate deviation, gotcha, or workaround.
- Never narrate the code ("loop over users", "parse the body"), restate names/types/signatures, or mark block ends.
- Never narrate the change ("fixed X", "updated to Y", "as requested"). A comment must read correctly to someone seeing the file fresh who never saw the diff; change context belongs in the commit message.
- Delete by default. A comment that just restates a decision the code already reflects — "1 vCPU is deliberate", "right-sized from prod" — is dead weight even when it points to a doc: the doc is where anyone questioning it looks anyway. Keep inline only what a reader needs *at that line* and can't get from the code — a non-obvious invariant/constraint ("timeout must stay < interval — ALB rule") or a cross-file sync obligation ("keep in sync with the router's TGs").
- Comments must stand on their own with any link removed — encode the substance, never a pointer as a substitute for it. Banned: specs, section numbers, design docs — point-in-time artifacts that get superseded and rot ("spec §7" is the canonical case). Fine: a maintained doc/README at a stable path — and when the *why* is a system-level narrative ("why it's built this way"), extract it there as a *pure* extraction: not an inline block, and not a comment that merely points to the doc. What stays inline are the non-obvious local details, which reference the doc only when a reader genuinely needs it *at that line* — a pointer-only comment generally shouldn't exist at all. Tickets, Confluence, RFCs, permalinks stay fine as trailing breadcrumbs.
- Occam's razor on every comment you *keep*, not just the ones you delete. "Carries a real *why*" and "is worded minimally" are independent judgments — a genuine *why* can still be 3x too long, and "it's a real why" is not license to keep the wording verbatim. Keep only the one non-obvious fact a reader needs *at that line*, in the fewest words; cut the mechanism the code already shows, where a value is consumed downstream, the consequence-of-the-consequence, and justification-of-the-justification. A 5-line block almost never survives intact — suspect it on sight; the razored answer is sometimes zero.
- A one-line summary on a public function/endpoint is fine; inline restatement of a single clear line never is.
- TODOs are fine and don't need issue IDs — but a TODO is a marker, not a substitute for doing the work in scope.

## Tests
- Default: do not write tests. Write one only when it is required (I asked for it, or the project's rules or CI demand it) or crucial (defined below).
- Crucial means a wrong result would be costly and would not be noticed: logic where an error silently corrupts data or conclusions (statistics, metrics, money, parsing or formatting of data that feeds an analysis), privacy or security filters (for example what an agent is allowed to see), code too subtle to verify by reading it or running it once, and a bug that has already happened once (a regression test for that bug).
- Not crucial: glue code, scripts and CLIs, config, thin wrappers, markup, CSS and layout, one-off or exploratory code, code whose output I see immediately when I run it, and anything a type checker or linter already covers.
- Test behaviour that matters, not the implementation. Write a few focused tests on the riskiest paths. Do not write tests that restate the code, assert on mocks, snapshot trivia, or exist to raise coverage. Never chase a coverage number.
- Before adding a test, be able to say in one line what risk it covers. If you cannot name the risk, skip it.
- If running the thing gives the same confidence (a dry run, a small real run, a screenshot, a `curl`), do that instead of writing a test.
- If the project already has a test suite: run it, keep it passing, and update existing tests that your change breaks. Add new tests only if the rules above apply.
- When in doubt, skip the test and say in one line what is untested, so I can ask for it. If I ask for tests, write them without arguing.

## Workflow
- Read a file before editing it. Grep for an existing pattern before writing a new one.
- Verify TODO checkboxes against the filesystem before reporting them done; a ticked box is a claim, not evidence. Do not re-litigate `[x]` items.
- Small diffs. One change per step.
- Edits to existing files inside the current project: edit in place and show `git diff`; no need to ask first. Commit, push, delete, dependency changes and anything outside the current project still need an explicit yes.
- **Obsidian vault notes are the exception.** Removing or overwriting more than 30 lines of existing content in a `.md` file under `~/obsidian-vault/` needs the sibling flow: show the merged draft and/or write `<name>.agent.md` beside the note, then wait for an explicit yes before touching the original. Code files are never subject to this.
- Ask before: delete, `sudo`, new dependency, touching `.env*`, writing outside the project, writing to `~/NTU/`.
- Verify before saying done: run tests, type check, or build. Report the result. Not run = say so.

## Spending money
- Before any run that calls paid APIs (LLM calls, cloud jobs), do a dry run or cost estimate first and ask before the real run. Never pass a confirmation-skipping flag such as `--yes` unless I explicitly ask. Smoke-test with the smallest possible run before a full one.
- For multi-phase experiments, finish and review one phase before starting the next. Ask before starting an expensive phase.

## Research experiments
- Log every trial or round as raw rows (JSONL or similar), not just summary statistics. Bootstrap intervals and manual review of model reasoning need the raw data.
- Do statistical inference at the level of the independent unit (for example the session), never on individual rounds.
- Run the positive control or sanity check first, before comparing conditions.
- Do not change a pre-registered design or analysis, and do not look at results between stages, without asking. If a metric is invalid under a condition, say so instead of silently reporting it.
- Before scaling up a run, check time-indexed data by hand for off-by-one errors (for example showing round *t*'s outcome before round *t* has happened).

### Pre-registration
- Tier it. One primary family of at most about 3 hypotheses carries the main claim, and that claim should rest on the most robust measurement. Label everything else secondary or conditional, with an explicit trigger: "runs if X by time T, else reported as not run".
- Do not declare an experiment while any of its settings are still open or its code does not run end to end.
- Before asking me to approve a pre-registration, write the declared analysis as code and run it end to end, in two places:
  - on the positive control's scripted strategies;
  - on a short pilot of every real model.

  If a declared measurement cannot be computed on the pilot, tell me before I approve.
- Run every declared test statistic on the fixed or null strategies (for example never-update). If a strategy with no mechanism for the effect still moves the statistic, the statistic is confounded; say so before declaring it.
- A launch check must check whether every declared measurement can be computed (for example probe letter mass), not just whether replies parse. If it shows a declared measurement will fail, stop and ask before the paid run continues.

## Dotfiles

`~/dotfiles` is the source of truth. Dotbot links it into `~/.config`, `~/.agents`, the agent homes (`~/.claude`, `~/.codex`, `~/.dsh`) and a few home files; nearly everything there is a symlink into the repo, not a copy.

- **The repo is pushed to a public remote.** Never commit personal information or secrets. For any secret-bearing file (`.env`, tokens, API keys), commit a `<name>.example` template with placeholder values and keep the real file gitignored.
- Edit config in `~/dotfiles`, never at the linked path. Same inode, but writing at the linked path looks like a change to installed state instead of to the repo.
- Never hand-fix a link. Change `install.conf.yaml` and run `./install`; dry run first with `./install --dry-run`. `clean: ["~"]` means a careless run can remove links.
- This file is `~/dotfiles/agents/AGENTS.md` (also `~/.agents/AGENTS.md`). Per-tool layers live beside the tool's config in the repo. Put a rule here only if it holds in every tool.
- Skills live in `~/dotfiles/agents/skills/<name>/SKILL.md`. Install shared skills globally (`npx skills add -g`); install into a project only when I ask for a project-scoped skill.
- If `./install` exits non-zero, read the output before assuming failure: cosmetic glob warnings (dotbot trying to link children of a directory that is already a symlink) also set a non-zero exit. Fix those with `exclude` entries, not by moving files.

## Notes and symlinks
- Before editing a markdown note, check whether it is a symlink (for example into an Obsidian vault). Obsidian can write an older copy back over an edit made elsewhere, so re-read the file after editing.

## Context files: `~/Chat` session directories
- `~/Chat` is the working directory for misc, non-coding quicklaunch sessions. It is not a project root.
- Sessions start with an unknown scope and may grow into coursework, system customisation, research, or similar. Do not assume a session is throwaway.
- Do not keep a single global `decisions.md` there. Create `~/Chat/<task-slug>/` per session, and set it as the session directory.
- Creating directories under `~/Chat` is pre-authorised. Every other operation there still needs permission.
- Each session dir gets two files:
  - `decisions.md` — append-only: rejected approaches with reasons, plus invariants. Never reordered. See the exception below before rewriting anything in it.
  - `handoff.md` — overwritten at each task boundary: goal, state, files touched, next action, open questions.
- Global, cross-project rules belong in this file, not in any `decisions.md`.
- Never delete a session directory unless I explicitly say so, for example "close this session". A finished task is not enough.

### Correcting a false statement in `decisions.md`

`decisions.md` is append-only so that a fresh session can see what was rejected and why. A record that can be quietly rewritten cannot do that job. This single exception covers factual claims only, not decisions.

Overwrite in place only when a statement is **factually wrong**: a wrong deadline, a wrong eligibility gate, a wrong affiliation, a wrong programme name. Rulings, rejected approaches, reasoning, and rankings are never overwritten. If an approach was wrong, append a correction; the original ruling stays.

Four conditions, all required:

1. **Established.** The claim is contradicted by a cited primary source, not by another summary.
2. **Disclosed.** The user is told what the line says, why it is wrong, and what replaces it. Silence is not approval.
3. **Approved.** The user approves that specific correction. Approval does not carry to a later run or to another line.
4. **Preserved.** The replacement quotes or summarises the false claim so the record of it survives. A reader of the file can still see that the error existed.

If any condition is unmet, append instead. Appending is always safe; overwriting is not.

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

## NTU

`~/NTU/` is read-only. Read course material from it freely; never write, move, rename, or delete anything there without an explicit yes for that specific file. Course scratch work, `decisions.md` and `handoff.md` belong in the matching `~/Chat/<course>/` session directory, not in `~/NTU/`.

## Academic
- User is a Y1 CS student at NTU.
- Graded work (assignment, quiz, lab): hints and bug checks only. No full solution.
- Practice or study: full worked answer OK.
- Explain reasoning from first principles on request.

## Personal data

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
