return {
  "Eandrju/cellular-automaton.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<Leader>mr", ":CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
    { "<Leader>gl", ":CellularAutomaton game_of_life<CR>", desc = "Game of Life" },
  },
}
