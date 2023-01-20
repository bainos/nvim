require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = {
    "bashls",
    "dockerls",
    "pyright",
    "sumneko_lua",
    "terraformls",
    "yamlls",
  },
  automatic_installation = false,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--
-- npm i -g bash-language-server
require'lspconfig'.bashls.setup{}

-- npm install -g dockerfile-language-server-nodejs
require'lspconfig'.dockerls.setup{}

-- https://github.com/microsoft/pyright
require'lspconfig'.pyright.setup{}

-- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line
require'lspconfig'.sumneko_lua.setup{}

-- https://github.com/hashicorp/terraform-ls/releases
require'lspconfig'.terraformls.setup{}

-- yarn global add yaml-language-server
require'lspconfig'.yamlls.setup{}

