return {
  {
    "kevinhwang91/nvim-hlslens",
    opts = {
      calm_down = false,
      nearest_only = true,
      nearest_float_when = "never",
    },
  },
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
    },
    config = function()
      require("scrollbar").setup {
        excluded_filetypes = { "neo-tree", "dropbar_menu" },
      }
      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar.handlers.search").setup {}
    end,
  },
}
