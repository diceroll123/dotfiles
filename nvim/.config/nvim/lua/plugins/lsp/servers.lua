return {
  jsonls = {
    settings = {
      json = {
        schema = require("schemastore").json.schemas(),
        validate = {
          enable = true,
        },
      },
    },
  },
  intelephense = {
    settings = {
      intelephense = {
        files = {
          maxSize = 1000000,
        },
      },
    },
  },
  lua_ls = {
    Lua = {
      telemetry = {
        enable = false,
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  },
  bashls = {
    filetypes = { "sh", "zsh" },
  },
  vimls = {
    filetypes = { "vim" },
  },
  -- tsserver = {},
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
  },
  basedpyright = {
    enabled = true,
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        -- checkOnSave = {
        --     command = "clippy"
        -- }
      },
    },
  },
  ruff = {
    enabled = true,
    keys = {
      {
        "<leader>co",
        function()
          vim.lsp.buf.code_action {
            apply = true,
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
          }
        end,
        desc = "Organize Imports",
      },
    },
    settings = {
      ruff = {
        -- pythonPath = "python3",
        -- pythonAnalysis = {
        --     typeCheckingMode = "basic"
        -- }
      },
    },
  },
}
