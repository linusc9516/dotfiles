# yabai-keys

> My yabai window manager shortcuts, defined in skhdrc.
> Every shortcut starts with `Ctrl + Alt`.

- Focus the window to the left / below / above / right:

`Ctrl + Alt + {{h}} {{j}} {{k}} {{l}}`

- Move the window in that direction:

`Ctrl + Alt + Shift + {{h}} {{j}} {{k}} {{l}}`

- Resize the window; add Shift to move the opposite edge instead:

`Ctrl + Alt + {{Left}} {{Down}} {{Up}} {{Right}}`

- Toggle fullscreen zoom / toggle floating:

`Ctrl + Alt + {{z}} / {{f}}`

- Next layout / stack layout / bsp (tiling) layout:

`Ctrl + Alt + {{Space}} / {{s}} / {{b}}`

- Rotate the layout 90 degrees / flip the split direction / balance sizes:

`Ctrl + Alt + {{r}} / {{v}} / {{e}}`

- Go to space 1-9 / space 10:

`Ctrl + {{1..9}} / {{0}}`

- Send the window to space 1-9 / space 10:

`Ctrl + Shift + {{1..9}} / {{0}}`

- Go to the previous / next space:

`Ctrl + {{-}} / {{=}}`

- Send the window to the previous / next space:

`Ctrl + Shift + {{-}} / {{=}}`

- Switch focus between the two displays:

`Ctrl + {{`}}`

- Focus kitty / VS Code, or open it if it is not running:

`Ctrl + Alt + {{t}} / {{c}}`

- Put every app back on its assigned space:

`~/.config/yabai/restore_spaces.sh`

- Restart yabai after changing its config:

`yabai --restart-service`
