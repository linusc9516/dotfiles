return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { theme = "catppuccin" } },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { spec = { { "<leader>f", group = "find" }, { "<leader>c", group = "code" }, { "<leader>g", group = "git" }, { "<leader>x", group = "diagnostics" } } },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File tree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal file in tree" },
    },
    opts = { view = { width = 32 }, filters = { dotfiles = false } },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
}
