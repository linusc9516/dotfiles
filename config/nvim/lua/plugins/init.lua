-- Deliberately small. Ask before adding more.
return {
  -- Colorscheme (carried over from the previous setup)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "macchiato" })
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
      require("telescope").setup()
    end,
  },
}
