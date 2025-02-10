return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  opts = function()
    return require "configs.bufferline"
  end,
  config = function(_, opts)
    require("bufferline").setup(opts)
  end,
}
