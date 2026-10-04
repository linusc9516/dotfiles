# Show my own pages from ~/.config/tldr/pages (for example `tldr tmux-keys`)
# and fall back to the normal tldr pages for everything else.
function tldr --wraps tldr --description 'tldr with personal pages'
    set -l page ~/.config/tldr/pages/$argv[1].md
    if test (count $argv) -eq 1; and test -f $page
        command tldr --render $page
    else
        command tldr $argv
    end
end
