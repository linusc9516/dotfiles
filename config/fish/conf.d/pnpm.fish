# Make `pnpm` available regardless of the active nvm Node version.
#
# Why this exists
# ---------------
# `corepack enable pnpm` only writes a shim into the *active* nvm version
# directory, e.g. ~/.local/share/nvm/v24.21.0/bin/pnpm. That shim is a relative
# symlink into that same versioned directory, so it disappears the moment you
# `nvm uninstall` that Node version or `nvm use` a different one. Since `dsh
# plugin` shells out to pnpm, that silently breaks plugin installs with
# `spawn pnpm ENOENT`.
#
# The shim in ~/.local/share/corepack-shims is a small wrapper that calls
# `corepack pnpm` for whichever Node is currently active, so it survives Node
# upgrades. Put it ahead of the nvm bin directory on PATH.
#
# Node still has to be active for pnpm to run -- the wrapper prints an explicit
# message rather than failing with a bare ENOENT if it is not.

set --local corepack_shims ~/.local/share/corepack-shims

if test -d $corepack_shims
    # Prepend so the version-independent wrapper wins over any per-version
    # shim that `corepack enable` may also have written into the nvm bin dir.
    fish_add_path --prepend --global $corepack_shims
end
