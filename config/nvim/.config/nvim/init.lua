vim.opt.guifont = "MesloLGS Nerd Font Mono:h" .. os.font_size

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_compiler_latexmk = { continuous = 1 }
vim.opt.shell = "/bin/zsh"
vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/venv/bin/python')

-- Load plugins
require("lazy").setup("plugins")
