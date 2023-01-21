SERVERS = {
  "bashls",
  "dockerls",
  "pyright",
  --"sumneko_lua",
  --"terraformls",
  "yamlls",
}

require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  ensure_installed = {
    "bash",
    "dockerfile",
    "python",
    --"lua",
    --"terraform",
    "vim",
    "yaml",
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false
}
)

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = SERVERS,
  automatic_installation = false,
})

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
      }
    }
  }
}

-- https://github.com/hashicorp/terraform-ls/releases
require 'lspconfig'.terraformls.setup {}

-- yarn global add yaml-language-server
require 'lspconfig'.yamlls.setup {}

