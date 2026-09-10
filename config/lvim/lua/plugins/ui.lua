
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,  -- Load immediately
    priority = 1000,
    config = function()  -- Add explicit config
      require("catppuccin").setup({
        flavour = "macchiato",
        integrations = { cmp = true, treesitter = true, telescope = true, mason = true },
        color_overrides = { macchiato = { lavender = "#C678DD" } },
      })
      vim.cmd.colorscheme("catppuccin")  -- APPLY HERE
    end,
  },
}
