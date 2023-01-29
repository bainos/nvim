local M = {}

function M.setup()
  local lsp_servers = {
    "bashls",
    "dockerls",
    "pyright",
    "sumneko_lua",
    "terraformls",
    "yamlls",
  }

  -- language servers manager
  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = lsp_servers,
    automatic_installation = false,
  })

  -- language server providers configuration
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  --
  -- npm i -g bash-language-server
  require 'lspconfig'.bashls.setup {}

  -- npm install -g dockerfile-language-server-nodejs
  require 'lspconfig'.dockerls.setup {}

  -- https://github.com/microsoft/pyright
  require 'lspconfig'.pyright.setup {}

  -- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line
  require 'lspconfig'.sumneko_lua.setup {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'use' }
        },
      }
    }
  }

  -- https://github.com/hashicorp/terraform-ls/releases
  require 'lspconfig'.terraformls.setup {}

  -- yarn global add yaml-language-server
  require 'lspconfig'.yamlls.setup {
    settings = {
      trace = {
        server = "debug"
      },
      yaml = {
        schemas = { kubernetes = "/*.yaml" },
      },
      schemaDownload = { enable = true },
      validate = true,
    }
  }

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false
  }
  )

  -- Setup lspconfig completion
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  for _, server in pairs(lsp_servers) do
    require('lspconfig')[server].setup {
      capabilities = capabilities
    }
  end

  -- Helm (alpha)
  -- https://github.com/mrjosh/helm-ls
  -- Manual install
  local configs = require('lspconfig.configs')
  local lspconfig = require('lspconfig')
  local util = require('lspconfig.util')

  if not configs.helm_ls then
    configs.helm_ls = {
      default_config = {
        cmd = { "helm_ls_linux_amd64", "serve" },
        filetypes = { 'helm' },
        root_dir = function(fname)
          return util.root_pattern('Chart.yaml')(fname)
        end,
      },
    }
  end

  lspconfig.helm_ls.setup {
    filetypes = { "helm" },
    cmd = { "helm_ls_linux_amd64", "serve" },
  }

end

return M
