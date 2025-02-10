return {
  "nvzone/menu",
  lazy = true,
  cmd = "NvzoneMenuOpen",
  dependencies = { "nvzone/volt", "nvzone/minty" },
  config = function()
    vim.api.nvim_create_user_command("NvzoneMenuOpen", function()
      require("menu").open "default"
    end, {})
  end,
  enabled = true,
}
