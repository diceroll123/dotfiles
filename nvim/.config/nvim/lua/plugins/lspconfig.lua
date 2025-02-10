return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "b0o/schemastore.nvim",
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
    require("lspconfig.ui.windows").default_options.border = "single"
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
    local lspconfig = require "lspconfig"

    for server, config in pairs(lsp_servers) do
      if config.enabled ~= false then
        lspconfig[server].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          on_init = on_init,
          settings = vim.tbl_deep_extend("force", config.settings or {}, opts),
          filetypes = config.filetypes,
        }
      end
    end

    -- Add ruff specific configuration
    lspconfig.ruff.setup {
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
    }

    -- Add rust_analyzer specific configuration
    lspconfig.rust_analyzer.setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
      settings = vim.tbl_deep_extend("force", {
        ["rust-analyzer"] = {
          -- Add any specific settings for rust_analyzer here
        },
      }, opts),
    }

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
