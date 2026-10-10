if not status is-interactive
    return
end

set fish_greeting

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
set -gx GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -gx EZA_CONFIG_DIR ~/.config/eza
fish_add_path -g ~/.opencode/bin
set -gx CONTEXT7_API_KEY (security find-generic-password -s context7 -w 2>/dev/null)
set -gx DEEPINFRA_API_KEY (security find-generic-password -s deepinfra -w 2>/dev/null)
set -gx DSH_TELEMETRY_MODE DISABLED
set -gx DSH_PERMISSION_MODE workspace-write

alias ls 'eza --icons -F -H --group-directories-first -1'
alias l 'eza --icons -F --group-directories-first'
alias cat 'bat'
alias find 'fd'
alias grep 'rg'
alias ... 'cd ../..'

alias mv 'mv -i'
alias cp 'cp -i'
alias ln 'ln -i'
alias mkdir 'mkdir -pv'

alias diff 'delta'
alias python 'python3'

abbr la 'ls -al'
abbr lt 'ls -T --level=3'
abbr recent 'ls -s modified -r'
abbr .. 'cd ..'
abbr cl clear
abbr hs history
abbr ghs 'history search'
abbr calc 'bc -l -q'
abbr ser http-server
abbr f fix
abbr src 'exec fish'
abbr sync-pkgs 'bash ~/dotfiles/scripts/sync-packages.sh'
abbr yrs 'yabai --restart-service'
abbr qch 'llm chat -t caveman'
abbr oc opencode
abbr pdf 'open -a Skim'

abbr g git
abbr gs 'git status'
abbr gd 'git diff'
abbr gc 'git checkout'
abbr gp 'git push'
abbr gpl 'git pull'
abbr gl 'git lg'
abbr lg 'lazygit'

zoxide init fish --cmd j | source
fixit init fish | source

# Tide prompt colours and tweaks. Exported (-g sets exported globals) so that
# the background process that renders the prompt sees them.
catppuccin_tide -g mocha
set -gx tide_time_format %H:%M
set -gx tide_git_icon \ue702 # nf-dev-git, the diamond git logo

