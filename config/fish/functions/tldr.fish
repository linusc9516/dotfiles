# Show my own pages from ~/.config/tldr/pages and fall back to the normal tldr
# pages for everything else. `tldr tmux` shows my tmux-keys page; use
# `command tldr tmux` for the official one.
function tldr --wraps tldr --description 'tldr with personal pages'
    if test (count $argv) -eq 1
        for name in $argv[1] $argv[1]-keys
            set -l page ~/.config/tldr/pages/$name.md
            if test -f $page
                command tldr --render $page
                return
            end
        end
    end
    command tldr $argv
end
