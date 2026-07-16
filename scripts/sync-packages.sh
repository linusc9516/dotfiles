#!/bin/bash
cd ~/dotfiles

if [[ "$(uname)" == "Darwin" ]]; then
    echo "→ Updating Brewfile..."
    brew bundle dump --force
    git add Brewfile
    git commit -m "Update Brewfile $(date +%Y-%m-%d)" || echo "No changes to commit"

elif [[ "$(uname)" == "Linux" ]]; then
    echo "→ Updating apt package list..."
    comm -23 <(apt-mark showmanual | sort) <(echo "gpg wget curl" | tr ' ' '\n' | sort) > packages.ubuntu
    git add packages.ubuntu
    git commit -m "Update apt packages $(date +%Y-%m-%d)" || echo "No changes to commit"
fi