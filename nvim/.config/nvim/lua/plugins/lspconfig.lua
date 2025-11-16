return {
  "b0o/schemastore.nvim",
  event = "VeryLazy",
  dependencies = {
    { "williamboman/mason.nvim", event = "VeryLazy" }, -- Optional
    { "hrsh7th/cmp-calc", event = "VeryLazy" },
    { "nvimtools/none-ls.nvim", event = "VeryLazy" },
    { "hrsh7th/cmp-cmdline", event = "VeryLazy" },
    { "williamboman/mason-lspconfig.nvim", event = "VeryLazy" }, -- Optional

    -- Autocompletion
    { "hrsh7th/nvim-cmp", event = "VeryLazy" }, -- Required
    { "hrsh7th/cmp-nvim-lsp", event = "VeryLazy" }, -- Required
    { "hrsh7th/cmp-buffer", event = "VeryLazy" }, -- Optional
    { "hrsh7th/cmp-path", event = "VeryLazy" }, -- Optional
    { "hrsh7th/cmp-nvim-lua", event = "VeryLazy" }, -- Optional
    { "hrsh7th/cmp-cmdline", event = "VeryLazy" }, -- Optional
  },
  opts = {
    inlay_hints = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("plugins.lsp.lspconfig").defaults()

    vim.diagnostic.config {
      title = false,
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = "always",
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    }

    local signs = {
      Error = " ",
      Warn = " ",
      Hint = "󰠠 ",
      Info = " ",
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = "",
      })
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local on_attach = function(client, bufnr)
      -- Enable inlay hints if supported by the server
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      require("plugins.lsp.lspconfig").on_attach(client, bufnr)
    end

    local on_init = require("plugins.lsp.lspconfig").on_init
    local lsp_servers = require "plugins.lsp.servers"

    for server, config in pairs(lsp_servers) do
      if config.enabled ~= false then
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach = on_attach,
          on_init = on_init,
          settings = vim.tbl_deep_extend("force", config.settings or {}, opts),
          filetypes = config.filetypes,
        })
      end
    end

    -- Add ruff specific configuration
    vim.lsp.config("ruff", {
      on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end
        on_attach(client, bufnr)
      end,
      on_init = on_init,
      capabilities = capabilities,
      settings = vim.tbl_deep_extend("force", {
        ruff = {
          -- Add any specific settings for ruff here
        },
      }, opts),
    })

    -- Add rust_analyzer specific configuration
    vim.lsp.config("rust_analyzer", {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
      settings = vim.tbl_deep_extend("force", {
        ["rust-analyzer"] = {
          -- Add any specific settings for rust_analyzer here
        },
      }, opts),
    })

    local cmp = require "cmp"

    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}
