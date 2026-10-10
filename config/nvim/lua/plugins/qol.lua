return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function m(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        m("]h", function() gs.nav_hunk("next") end, "Next hunk")
        m("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        m("<leader>gp", gs.preview_hunk, "Preview hunk")
        m("<leader>gr", gs.reset_hunk, "Reset hunk")
        m("<leader>gb", gs.blame_line, "Blame line")
      end,
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { default_file_explorer = false, view_options = { show_hidden = true } },
    keys = { { "-", "<cmd>Oil<CR>", desc = "Open parent directory (oil)" } },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      -- Python is formatted by ruff via LSP (lua/lsp.lua); conform handles the rest
      formatters_by_ft = { lua = { "stylua" } },
      format_on_save = { timeout_ms = 2000, lsp_format = "never" },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (all)" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
    },
  },
}
