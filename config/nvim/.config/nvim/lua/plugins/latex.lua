return {
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_syntax_conceal = {
        math_bounds = 0,   -- Don't conceal the $ math mode delimiters
        accents = 1,       -- Conceal accents
        ligatures = 1,     -- Conceal ligatures
        greek = 1,         -- Conceal greek letters
        math_symbols = 1,  -- Conceal math symbols
        math_fracs = 1,    -- Conceal \frac and similar
        math_super_sub = 1,-- Conceal superscripts/subscripts (often buggy)
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          vim.fn.writefile({ vim.v.servername }, "/tmp/vimtexserver.txt")
        end,
      })
    end,
  },

  {
    "SirVer/ultisnips",
    dependencies = { "honza/vim-snippets" },
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
    end,
  },

  { "godlygeek/tabular", ft = "tex" },
  { "jbyuki/nabla.nvim", ft = "tex" },
}
