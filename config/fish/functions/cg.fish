function cg --description 'cd to the git repo root'
    set -l root (git rev-parse --show-toplevel 2>/dev/null); and cd $root
end
