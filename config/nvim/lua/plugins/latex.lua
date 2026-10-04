return {
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_compiler_latexmk = { continuous = 1 }
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_syntax_conceal = {
        math_bounds = 0, accents = 1, ligatures = 1, greek = 1,
        math_symbols = 1, math_fracs = 1, math_super_sub = 1,
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function(args)
          vim.opt_local.conceallevel = 2
          vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { buffer = args.buf, desc = "Compile LaTeX" })
          vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { buffer = args.buf, desc = "View PDF" })
        end,
      })
    end,
  },

  {
    "SirVer/ultisnips",
    init = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
    end,
  },
}
