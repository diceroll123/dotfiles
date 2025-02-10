local map = vim.keymap.set

map("n", ";", ":", {
  desc = "Cmd enter command mode",
})

map("n", "<leader>fm", function()
  require("conform").format {
    lsp_fallback = true,
  }
end, {
  desc = "Format file",
})

map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "general save file" })

map("n", "cc", "ciw", { desc = "change current word", noremap = true })

-- modify macro recording keymap to avoid hitting by accident
map("n", "q", "<nop>", { noremap = true })

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", {
  desc = "Move line down",
})
map("v", "K", ":m '<-2<CR>gv=gv", {
  desc = "Move line up",
})

-- Move current line / block of text in normal mode
map("n", "J", "mzJ`z")

-- Move up and down without moving the cursor
map("n", "<C-d>", "0<C-d>zz")
map("n", "<C-u>", "0<C-u>zz")
map("n", "<PageDown>", "0<C-d>zz")
map("n", "<PageUp>", "0<C-u>zz")

-- Select next/previous and keep text centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste without yanking
map("x", "<leader>p", [["_dP]])

-- Select all
map("n", "<C-a>", "ggVG")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Replace word under cursor
map("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Move to beginning of line, or first character, using HOME
local function smart_home()
  local col = vim.fn.col "."
  if col == 1 then
    return vim.api.nvim_replace_termcodes("^", true, true, true)
  else
    return vim.api.nvim_replace_termcodes("0", true, true, true)
  end
end

vim.keymap.set({ "n", "v" }, "<Home>", smart_home, { expr = true, silent = true, desc = "Jump to front of line" })

-- Code Actions
map("n", "<leader>ca", function()
  require("tiny-code-action").code_action()
end, {
  noremap = true,
  silent = true,
  desc = "Code Action",
})

map("n", "Q", "<nop>", {
  desc = "disabled",
})

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", {
  desc = "Whichkey all keymaps",
})
map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, {
  desc = "Whichkey query lookup",
})
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", {
  desc = "Find keymaps",
})

-- Comment
map("n", "<leader>/", "gcc", {
  desc = "Toggle Comment",
  remap = true,
})
map("v", "<leader>/", "gc", {
  desc = "Toggle Comment",
  remap = true,
})

-- snacks explorer
map("n", "<C-n>", function()
  Snacks.picker.explorer()
end, {
  desc = "Snacks explorer toggle window",
})

-- Buffers
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Kill buffer" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev warning" })

-- NvZone Menu
vim.keymap.set("n", "<C-t>", function()
  require("menu").open "default"
end, {})
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require("menu.utils").delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})

-- Neovide
if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set({ "n", "v" }, "<D-v>", '"+P') -- Paste normal and visual mode
  vim.keymap.set({ "i", "c" }, "<D-v>", "<C-R>+") -- Paste insert and command mode
  vim.keymap.set("t", "<D-v>", [[<C-\><C-N>"+P]]) -- Paste terminal mode
end
