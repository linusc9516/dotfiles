return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin-nvim",
        globalstatus = true,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { { "branch", icon = "" }, { "diff", symbols = { added = " ", modified = " ", removed = " " } } },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "●", readonly = "", unnamed = "[No Name]" } },
          { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " } },
        },
        lualine_x = {
          {
            -- Names of the language servers attached to this buffer
            function()
              local names = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                names[#names + 1] = client.name
              end
              return #names > 0 and " " .. table.concat(names, " ") or ""
            end,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", icon = "" } },
      },
      extensions = { "nvim-tree", "lazy", "oil", "trouble", "quickfix" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = { { "<leader>f", group = "find" }, { "<leader>c", group = "code" }, { "<leader>g", group = "git" }, { "<leader>x", group = "diagnostics" } },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File tree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal file in tree" },
    },
    opts = {
      view = { width = 32 },
      filters = { dotfiles = false },
      renderer = {
        root_folder_label = ":t",
        indent_markers = { enable = true },
        highlight_git = "name",
        icons = { git_placement = "after" },
      },
    },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
}
