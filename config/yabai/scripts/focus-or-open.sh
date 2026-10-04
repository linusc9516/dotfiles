#!/bin/bash

app="$1"
if [ -z "$app" ]; then
    echo "Usage: $0 <app-name>" >&2
    exit 1
fi

# Get the first window ID of that application from yabai
win_id=$(yabai -m query --windows | jq -r ".[] | select(.app==\"$app\") | .id" | head -1)

if [ -n "$win_id" ]; then
    # Focus the existing window
    yabai -m window --focus "$win_id"
else
    # Launch the application
    open -a "$app"
fi