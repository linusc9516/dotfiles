return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- lets :Telescope load it too
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    },
    config = function()
      require("telescope").setup()
    end,
  },
}
