return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  opts = function()
    return require "configs.mason"
  end,
}
