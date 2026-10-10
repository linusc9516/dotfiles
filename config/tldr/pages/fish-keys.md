# fish-keys

> My fish aliases, abbreviations and functions. Run it as `tldr fish`.
> Abbreviations expand as you type (space or Enter); aliases and functions run as-is.
> Source: `~/dotfiles/config/fish/config.fish` and `functions/`.

- List files (one per line, icons) / short columns / with hidden files and details:

`{{ls}} / {{l}} / {{la}}`

- Show a tree three levels deep / most recently modified last:

`{{lt}} / {{recent}}`

- Go up one / two directories, or jump to a frecent directory (zoxide):

`{{..}} / {{...}}  /  {{j}} {{dir}}`

- Go to the root of the current git repo (function, does nothing outside a repo):

`{{cg}}`

- Git status / diff / checkout / push / pull / lazygit:

`{{gs}} / {{gd}} / {{gc}} / {{gp}} / {{gpl}} / {{lg}}`

- Pretty git log graph (`git lg`, defined in `~/.gitconfig`):

`{{gl}}`

- Stage everything and commit; no quotes needed around the message (function):

`{{gac}} {{fix the bug}}`

- Search shell history / list history:

`{{ghs}} {{text}}  /  {{hs}}`

- Restart fish cleanly (instead of re-sourcing config.fish) / clear the screen:

`{{src}} / {{cl}}`

- Restart the yabai window manager service:

`{{yrs}}`

- Quick calculator / serve the current directory over HTTP:

`{{calc}}  /  {{ser}}`

- Fix the previous failed command (fixit) / sync Homebrew packages into dotfiles:

`{{f}}  /  {{sync-pkgs}}`

- Ask the LLM (DeepInfra, DeepSeek V4.1 Flash): caveman style / plain / follow up on the last answer:

`{{q}} {{question}}  /  {{qq}} {{question}}  /  {{qc}} {{follow up}}`

- Interactive LLM chat in caveman style (`-m glm` or `-m oss` for another model, Ctrl+D to leave; plain chat is `llm chat`):

`{{qch}}`

- Start the opencode agent in the current directory (DeepInfra, DeepSeek V4.1 Flash; `/models` switches model):

`{{oc}}`

- Pipe a file into the LLM / search past LLM answers:

`{{cat file}} | {{q}} {{summarize}}  /  {{llm logs -q}} {{keyword}}`

- Commands I replaced with better tools (interactive shells only): `cat` is bat, `find` is fd, `grep` is rg, `diff` is delta, `python` is python3:

`{{cat}} {{file}}  /  {{find}} {{pattern}}  /  {{grep}} {{pattern}}`

- Safety flags: `mv`, `cp` and `ln` ask before overwriting, `mkdir` creates parents and is verbose:

`{{mv}} {{a}} {{b}}  /  {{mkdir}} {{a/b/c}}`

- List everything live:

`{{abbr --show}}  /  {{alias}}  /  {{functions --names}}`
