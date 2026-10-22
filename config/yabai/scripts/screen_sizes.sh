#!/bin/sh
# Prints "BAR GAP YOFF BTN" in px. With "apply": also pushes them to yabai and sketchybar.
BAR_PCT=4
BTN_RATIO=90
GAP=8
YOFF=0

H=$(yabai -m query --displays --display | /usr/bin/jq '.frame.h | floor')
BAR=$(( H * BAR_PCT / 100 ))
BTN=$(( BAR * BTN_RATIO / 100 ))

if [ "$1" = apply ]; then
  yabai -m config external_bar all:$(( BAR + YOFF )):0 \
    top_padding 0 bottom_padding "$GAP" \
    left_padding "$GAP" right_padding "$GAP" window_gap "$GAP"
  /opt/homebrew/bin/sketchybar --bar height="$BAR" y_offset="$YOFF"
else
  echo "$BAR $GAP $YOFF $BTN"
fi
