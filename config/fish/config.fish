if not status is-interactive
    return
end

set fish_greeting

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
set -gx GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -gx EZA_CONFIG_DIR ~/.config/eza

alias ls 'eza --icons -F -H --group-directories-first -1'
alias la 'ls -alF'
alias l 'ls -CF'
alias lt 'ls -T --level=3 --classify'
alias cat 'bat'
alias find 'fd'
alias grep 'rg'

alias .. 'cd ..'
alias ... 'cd ../..'
alias cg 'cd (git rev-parse --show-toplevel)'

alias mv 'mv -i'
alias cp 'cp -i'
alias ln 'ln -i'
alias mkdir 'mkdir -pv'

alias cl 'clear'
alias calc 'bc -l -q'
alias diff 'colordiff'
alias recent 'ls -t -1'
alias hs 'history'
alias ghs 'history | grep'
alias src 'source ~/.config/fish/config.fish'
alias ser 'http-server'
alias pfetch 'PF_INFO="ascii title os host kernel uptime pkgs memory" PF_ASCII="catppuccin" /usr/local/bin/pfetch'
alias f 'fix'
alias sync-pkgs 'bash ~/dotfiles/scripts/sync-packages.sh'

abbr g git
abbr gs 'git status'
abbr gd 'git diff'
abbr gc 'git checkout'
abbr gp 'git push'
abbr gpl 'git pull'
abbr gac 'git add .; and git commit -m'
abbr gl "git log --topo-order --all --graph --date=local --pretty=format:'%C(green)%h%C(reset) %><(55,trunc)%s%C(red)%d%C(reset) %C(blue)[%an]%C(reset) %C(yellow)%ad%C(reset)%n'"
abbr lg 'lazygit'

zoxide init fish | source
fixit init fish | source
rose_pine_tide moon
pfetch

source "$HOME/.cargo/env.fish"

fish_add_path /Users/linusc/.spicetify
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin