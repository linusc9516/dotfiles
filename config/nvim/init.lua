-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.o
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.mouse = "a"
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.splitright = true
o.splitbelow = true
o.updatetime = 250
o.confirm = true
o.completeopt = "menuone,noselect,popup"
o.winborder = "rounded"

-- Look and feel
o.termguicolors = true
o.laststatus = 3 -- one statusline for the whole screen
o.showmode = false -- lualine shows the mode
o.pumheight = 12
o.smoothscroll = true
o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { eob = " ", diff = "╱", fold = " " }

-- 4 spaces by default (Python); 2 for web/config files
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "yaml", "json", "javascript", "typescript", "html", "css" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})

local sev = vim.diagnostic.severity
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { prefix = "●", spacing = 2 },
  signs = { text = { [sev.ERROR] = " ", [sev.WARN] = " ", [sev.INFO] = " ", [sev.HINT] = "󰌵 " } },
  float = { source = true },
})

-- Flash the text that was just yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 180 })
  end,
})

-- Keymaps
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Close window" })
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Run the current file with uv in a bottom terminal split
map("n", "<leader>rr", function()
  vim.cmd("write")
  vim.cmd("botright 12split | terminal uv run " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Run file with uv" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  checker = { enabled = false },
  ui = { border = "rounded", backdrop = 100 },
  change_detection = { notify = false },
})

require("lsp")
