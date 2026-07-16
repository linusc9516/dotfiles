#!/bin/bash
set -e

sudo apt update
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y \
  base-files bash bat bsdutils build-essential coreutils curl dash \
  debianutils diffutils eza fastfetch fd-find fdclone findutils fish fixit \
  fzf gh git git-delta grep gzip hostname init libattr1 login \
  ncurses-base ncurses-bin nodejs npm python3-dev ripgrep sesh tmux \
  ubuntu-minimal ubuntu-wsl util-linux wget wslu zoxide \
  tldr

echo "→ Setting fish as default shell..."
FISH_PATH="$(command -v fish)"
echo "$FISH_PATH" | sudo tee -a /etc/shells
sudo chsh -s "$FISH_PATH" "$USER"
