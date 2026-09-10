#!/bin/bash
set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --file=~/dotfiles/Brewfile

gh extension install dlvhdr/gh-dash

# curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

FISH_PATH="$(command -v fish)"
echo "$FISH_PATH" | sudo tee -a /etc/shells
chsh -s "$FISH_PATH"

brew services restart sketchybar
yabai --start-service
skhd --start-service
