M = {}
M.on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, {
      buffer = bufnr,
      desc = desc,
    })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
  nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("go", vim.lsp.buf.type_definition, "Type Definition")
  -- nmap("gD", vim.lsp.buf.declaration, "Goto Declaration") -- nobody uses this
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
end

M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  vim.lsp.config("lua_ls", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })
end

return M
