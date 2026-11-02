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

## Workflow
- Read file before editing. Grep for existing pattern before writing new.
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
