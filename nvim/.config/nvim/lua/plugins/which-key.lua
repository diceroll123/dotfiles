return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
    },
  },
  keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
  cmd = "WhichKey",
}
