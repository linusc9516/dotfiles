#!/bin/bash
set -e

echo "→ Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "→ Installing Brewfile packages..."
brew bundle --file=~/dotfiles/Brewfile

echo "→ Installing gh-dash extension..."
gh extension install dlvhdr/gh-dash

echo "→ Only manually install spicetify-cli afterwards"
# curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

echo "→ Setting fish as default shell..."
FISH_PATH="$(command -v fish)"
echo "$FISH_PATH" | sudo tee -a /etc/shells
chsh -s "$FISH_PATH"

echo "→ Starting sketchybar..."
brew services restart sketchybar

echo "→ Starting yabai & skhd..."
yabai --start-service
skhd --start-service
