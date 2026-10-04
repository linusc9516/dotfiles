# tmux-keys

> My tmux key bindings. Press the prefix `Ctrl + a` first, then the key.
> "(mine)" marks bindings from tmux.conf; the rest are tmux or plugin defaults.

- Focus the pane to the left / below / above / right (mine):

`prefix {{h}} {{j}} {{k}} {{l}}`

- Swap the pane with its neighbour, focus follows (mine):

`prefix {{H}} {{J}} {{K}} {{L}}`

- Resize the pane; the arrow can be repeated without the prefix (mine):

`prefix {{Left}} {{Down}} {{Up}} {{Right}}`

- Split side by side / stacked, in the current directory (mine):

`prefix {{v}} / {{s}}`

- Zoom the pane to fill the window / cycle through layouts:

`prefix {{z}} / {{Space}}`

- Rotate the panes / spread them evenly / tiled layout (mine):

`prefix {{r}} / {{e}} / {{b}}`

- Close the pane / the whole window, without confirmation (mine):

`prefix {{x}} / {{&}}`

- Send the pane to another window (mine) / break it out into a new window:

`prefix {{m}} / {{!}}`

- Show pane numbers (press one to jump) / next pane / previously active pane:

`prefix {{q}} / {{o}} / {{;}}`

- New window in the current directory / rename window / rename session:

`prefix {{c}} / {{,}} / {{$}}`

- Go to window 1-9 / window 10 / previous / next window (0, - and = are mine):

`prefix {{1..9}} / {{0}} / {{-}} / {{=}}`

- Last used window / pick a window from a list / find a window by name:

`prefix {{a}} / {{w}} / {{f}}`

- Detach from the session / switch to the previous / next session:

`prefix {{d}} / {{(}} / {{)}}`

- Enter copy mode (scroll back) / paste from the system clipboard (mine):

`prefix {{[}} / {{p}}`

- In copy mode: start selecting / copy to the system clipboard / leave:

`{{v}} / {{y}} / {{q}}`

- Copy the current command line / working directory to the clipboard (tmux-yank):

`prefix {{y}} / {{Y}}`

- Save / restore all sessions (tmux-resurrect):

`prefix {{Ctrl + s}} / {{Ctrl + r}}`

- Install / update plugins (tpm):

`prefix {{I}} / {{U}}`

- Reload tmux.conf (mine) / list every binding / open the command prompt:

`prefix {{R}} / {{?}} / {{:}}`
