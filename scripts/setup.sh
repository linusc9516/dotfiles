#!/bin/bash
set -e

echo "→ Installing Fisher and plugins..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install PatrickF1/fzf.fish"
fish -c "fisher install jorgebucaran/nvm.fish"
fish -c "fisher install edc/bass"
fish -c "fisher install ilancosman/tide@v6"
fish -c "fisher install rose-pine/tide"

echo "→ Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "→ Creating fd symlink..."
mkdir -p ~/.local/bin
ln -sf "$(which fdfind)" ~/.local/bin/fd

echo "→ Configuring Tide..."
fish -c "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Round --powerline_prompt_style='Two lines, character' --prompt_connection=Disconnected --powerline_right_prompt_frame=No --prompt_spacing=Sparse --icons='Many icons' --transient=No"

echo "→ Installing Rust and Cargo..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

echo "→ Setting up global .gitignore and .gitconfig..."
git config --global core.excludesfile ~/.gitignore
git config --global include.path ~/.gitconfig