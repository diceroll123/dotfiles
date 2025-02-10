vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

require "utils.hjkl-notifier"

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({ {
  import = "plugins",
} }, lazy_config)

require("mason").setup()
require("stopinsert").setup()
require("gitsigns").setup()
require("octo").setup()
require("numb").setup()
require("scrollbar").setup()
require("colorizer").setup {
  user_default_options = {
    names_opts = {
      lowercase = true,
      camelcase = true,
      uppercase = true,
      strip_digits = false,
    },
    names = true,
    RGB = true,
    RGBA = true,
    RRGGBB = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = "virtualtext",
    virtualtext_inline = false,
    virtualtext = "■",
    virtualtext_mode = "foreground",
    always_update = false,
  },
}

require "options"

vim.schedule(function()
  require "mappings"
end)

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }
