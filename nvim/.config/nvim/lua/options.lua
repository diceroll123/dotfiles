local opt = vim.opt
local o = vim.o
local g = vim.g
o.guifont = "Comic Code Ligatures"
o.clipboard = "unnamedplus" -- copy/paste to system clipboard
o.cursorline = true
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true -- enable relative line numbers
o.number = true -- enable absolute line numbers
o.wrap = false -- disable line wrap
o.expandtab = true -- convert tabs to spaces
o.smartindent = true -- make indenting smarter again
o.softtabstop = 4 -- number of spaces a tab counts for
o.mousemoveevent = true -- enable mouse support
o.showmode = false
o.termguicolors = true -- enable true colors

-- folds
o.foldmethod = "indent"
o.foldcolumn = "1" -- '0' is not bad
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 99
o.foldenable = true

o.swapfile = false -- disable swap file
o.backup = false -- disable backup file

o.hlsearch = false -- disable highlighting search
o.incsearch = true -- show search matches as you type

o.scrolloff = 8 -- minimum number of screen lines to keep above and below the cursor

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

vim.cmd.colorscheme "catppuccin"

g.camelsnek_i_am_an_old_fart_with_no_sense_of_humour_or_internet_culture = 1

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- automatically toggle relative line number
vim.api.nvim_create_augroup("auto_relativenumber_toggle", {
  clear = true,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = "auto_relativenumber_toggle",
  pattern = "*",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = "auto_relativenumber_toggle",
  pattern = "*",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

vim.api.nvim_create_augroup("DashboardAutoOpen", { clear = true })
vim.api.nvim_create_autocmd({ "BufDelete" }, {
  group = "DashboardAutoOpen",
  callback = function()
    vim.schedule(function()
      local buffers = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= ""
      end, vim.api.nvim_list_bufs())

      if #buffers == 0 then
        vim.cmd "lua Snacks.dashboard()"
      end
    end)
  end,
})

-- Neovide
if vim.g.neovide then
  vim.g.neovide_input_macos_option_key_is_meta = "both"
end

-- Enable spellcheck and line wrapping in select file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
