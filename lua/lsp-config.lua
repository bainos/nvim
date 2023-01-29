local M = {}

function M.setup()
    local lsp_servers = {
        'bashls',
        'dockerls',
        'pyright',
        'sumneko_lua',
        'terraformls',
        'yamlls',
    }

    -- language servers manager
    require 'mason'.setup {}
    require 'mason-lspconfig'.setup {
        ensure_installed = lsp_servers,
        automatic_installation = false,
    }

    -- language server providers configuration
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
    -- npm i -g bash-language-server
    require 'lspconfig'.bashls.setup {
        capabilities = capabilities,
    }

    -- npm install -g dockerfile-language-server-nodejs
    require 'lspconfig'.dockerls.setup {
        capabilities = capabilities,
    }

    -- https://github.com/microsoft/pyright
    require 'lspconfig'.pyright.setup {
        capabilities = capabilities,
    }

    -- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    require 'lspconfig'.sumneko_lua.setup {
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { 'vim', 'use', },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file('', true),
                },
                --format = { enable = false },
                format = {
                    enable = true,
                    -- Put format options here
                    -- NOTE: the value should be STRING!!
                    defaultConfig = {
                        indent_style = 'space',
                        indent_size = '4',
                    },
                },
            },
        },
    }

    -- https://github.com/hashicorp/terraform-ls/releases
    require 'lspconfig'.terraformls.setup {
        capabilities = capabilities,
    }

    -- yarn global add yaml-language-server
    require 'lspconfig'.yamlls.setup {
        capabilities = capabilities,
    }

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    })
end

return M
