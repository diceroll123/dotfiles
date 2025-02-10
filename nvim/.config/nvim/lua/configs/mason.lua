return {
  PATH = "skip",
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  max_concurrent_installers = 10,
  ensure_installed = vim.tbl_keys(require "plugins.lsp.servers"),
}
