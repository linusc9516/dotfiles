#!/usr/bin/env bash

defaults write com.apple.dock mru-spaces -bool false

# Assign apps to specific spaces.
# The label makes re-running this script replace the rule instead of adding a duplicate.
# NOTE: the app regex is case-sensitive.
assign() {
  yabai -m rule --add label="$1" app="$2" space="$3"
}

assign code     '^Code$'              1
assign kitty    '^kitty$'             1
assign obsidian '^Obsidian$'          2
assign zen      '^Zen$'               3
assign chrome   '^Google Chrome$'     4
assign claude   '^Claude$'            5
assign outlook  '^Microsoft Outlook$' 6
assign dorion   '^Dorion$'            7
assign telegram '^Telegram$'          8
assign zapfast  '^ZapFast$'           8
assign spotify  '^Spotifast$'         9

# Rules only affect windows that open after the rule was added,
# so apply them to the windows that are already open as well.
yabai -m rule --apply

# Let the bar pick up hidden windows that were moved (see sketchybar items/spaces.lua)
command -v sketchybar >/dev/null && sketchybar --trigger spaces_restored

# Optional: Set default layouts for each space
for space in 1 2 3 4 5 6 7 8 9; do
  yabai -m space "$space" --layout bsp
done
