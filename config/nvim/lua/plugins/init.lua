-- Deliberately small. Ask before adding more.
return {
  -- Colorscheme (carried over from the previous setup)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        auto_integrations = true,
        styles = { comments = { "italic" }, keywords = { "italic" } },
        integrations = {
          -- Mauve is the accent: normal mode takes it, visual mode gets blue instead
          lualine = {
            all = function(c)
              return {
                normal = { a = { bg = c.mauve, fg = c.base }, b = { fg = c.mauve } },
                visual = { a = { bg = c.blue, fg = c.base }, b = { fg = c.blue } },
                inactive = { a = { fg = c.mauve } },
              }
            end,
          },
        },
        custom_highlights = function(c)
          return {
            CursorLineNr = { fg = c.mauve, style = { "bold" } },
            Title = { fg = c.mauve, style = { "bold" } },
            FloatBorder = { fg = c.mauve },
            FloatTitle = { fg = c.mauve, style = { "bold" } },
            WinSeparator = { fg = c.surface1 },
            PmenuSel = { bg = c.surface0, fg = c.mauve, style = { "bold" } },
            IncSearch = { bg = c.mauve, fg = c.base },
            CurSearch = { bg = c.mauve, fg = c.base },
            MatchParen = { fg = c.mauve, bg = c.surface1, style = { "bold" } },

            TelescopeBorder = { fg = c.mauve },
            TelescopeTitle = { fg = c.mauve, style = { "bold" } },
            TelescopePromptPrefix = { fg = c.mauve },
            TelescopeSelectionCaret = { fg = c.mauve, bg = c.surface0 },
            TelescopeSelection = { bg = c.surface0, style = { "bold" } },
            TelescopeMatching = { fg = c.mauve, style = { "bold" } },

            NvimTreeRootFolder = { fg = c.mauve, style = { "bold" } },
            NvimTreeFolderIcon = { fg = c.mauve },
            NvimTreeOpenedFolderName = { fg = c.mauve, style = { "bold" } },
            NvimTreeIndentMarker = { fg = c.surface1 },
            NvimTreeWinSeparator = { fg = c.surface1 },

            WhichKey = { fg = c.mauve },
            WhichKeyGroup = { fg = c.mauve },
            WhichKeyBorder = { fg = c.mauve },
            WhichKeyTitle = { fg = c.mauve, style = { "bold" } },

            FlashLabel = { bg = c.mauve, fg = c.base, style = { "bold" } },
            LazyH1 = { bg = c.mauve, fg = c.base, style = { "bold" } },
            LazyButtonActive = { bg = c.mauve, fg = c.base, style = { "bold" } },
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Syntax highlighting. "main" is the branch rewritten for Neovim 0.12.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "python", "lua", "vim", "vimdoc", "bash", "markdown", "markdown_inline",
        "json", "yaml", "toml", "regex", "query",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- tex keeps regex syntax: vimtex's conceal and syntax rely on it
          if vim.bo[args.buf].filetype == "tex" then
            return
          end
          -- pcall: silently skip filetypes with no parser installed
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- Fuzzy finder (uses fd and rg if installed)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_config = { horizontal = { prompt_position = "top", preview_width = 0.55 }, width = 0.87, height = 0.8 },
          path_display = { "truncate" },
        },
      })
    end,
  },
}
