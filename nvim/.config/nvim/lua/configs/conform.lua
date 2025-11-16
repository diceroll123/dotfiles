return {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
    rust = { "rustfmt" },
    markdown = { "prettier" },
    javascript = { "prettier" },
    javascriptscript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
    quiet = true,
    async = false,
  },
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },
    },
  },
}
