return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = 3
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    config = function()
      vim.o.laststatus = vim.g.lualine_laststatus

      -- Safely get background color from 'StatusLine' instead of lualine theme
      local statusline_bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
      local comment_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg

      if statusline_bg and comment_fg then
        vim.api.nvim_set_hl(0, "LualineMuted", { fg = comment_fg, bg = statusline_bg })
      end

      local function colored_filename()
        local full_path = vim.fn.expand "%:p" -- Get full path
        if full_path == "" then
          return "[No Name]"
        end

        -- Replace $HOME with ~
        local home = vim.fn.expand "$HOME"
        if full_path:find(home, 1, true) then
          full_path = full_path:gsub("^" .. vim.pesc(home), "~")
        end

        local dir = vim.fn.fnamemodify(full_path, ":h") .. "/" -- Directory
        local file = vim.fn.fnamemodify(full_path, ":t") -- Filename

        -- Use the custom muted highlight for directories
        local hl_muted = "%#LualineMuted#"
        local hl_normal = "%#StatusLine#" -- Use the default statusline color

        return string.format("%s%s%s%s", hl_muted, dir, hl_normal, file)
      end

      require("lualine").setup {
        options = {
          theme = "catppuccin",
          disabled_filetypes = {
            statusline = { "dashboard" },
          },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diagnostics", "diff" },
          lualine_c = { colored_filename, "lsp_progress" },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
}
