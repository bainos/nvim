local M = {}

function M.setup()
    --local lsp_servers = {
    --'bashls',
    --'ruff_lsp',
    --'pyright',
    --'yamlls',
    --}

    --if not require 'termux'.is_termux() then
    --table.insert(lsp_servers, 'lua_ls')
    --table.insert(lsp_servers, 'dockerls')
    --table.insert(lsp_servers, 'terraformls')
    --table.insert(lsp_servers, 'helm_ls')
    --table.insert(lsp_servers, 'azure_pipelines_ls')
    --table.insert(lsp_servers, 'rust_analyzer')
    --end

    local lsp_servers = { 'bashls', }

    if os.getenv 'HOST' == 'archtab' then
        table.insert(lsp_servers, 'lua_ls')
        table.insert(lsp_servers, 'rust_analyzer')
    end

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
        filetypes = { 'bash', 'sh', 'zsh', },
    }

    -- npm install -g dockerfile-language-server-nodejs
    require 'lspconfig'.dockerls.setup {
        capabilities = capabilities,
    }

    -- https://github.com/microsoft/pyright
    require 'lspconfig'.pyright.setup {
        capabilities = capabilities,
        handlers = {
            ['textDocument/publishDiagnostics'] = function(...) end,
        },
    }

    -- https://github.com/charliermarsh/ruff-lsp
    require 'lspconfig'.ruff_lsp.setup {
        init_options = {
            settings = {
                -- Any extra CLI arguments for `ruff` go here.
                args = {},
            },
        },
    }

    -- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    require 'lspconfig'.lua_ls.setup {
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
                    globals = { 'vim', 'use', 'bufnr', },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
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

    -- Helm (alpha)
    -- https://github.com/mrjosh/helm-ls
    -- Manual install
    --local configs = require 'lspconfig.configs'
    --local lspconfig = require 'lspconfig'
    --local util = require 'lspconfig.util'

    --if not configs.helm_ls then
    --configs.helm_ls = {
    --default_config = {
    --cmd = { 'helm_ls_linux_amd64', 'serve', },
    --filetypes = { 'helm', },
    --root_dir = function(fname)
    --return util.root_pattern 'Chart.yaml' (fname)
    --end,
    --},
    --}
    --end

    --lspconfig.helm_ls.setup {
    --capabilities = capabilities,
    --filetypes = { 'helm', },
    --cmd = { 'helm_ls_linux_amd64', 'serve', },
    --}

    local util = require 'lspconfig.util'
    require 'lspconfig'.helm_ls.setup {
        capabilities = capabilities,
        filetypes = { 'helm', },
        root_dir = function(fname)
            return util.root_pattern 'Chart.yaml' (fname)
        end,
    }

    -- yarn global add yaml-language-server
    require 'lspconfig'.yamlls.setup {
        on_attach = function()
            if vim.bo.buftype ~= '' or vim.bo.filetype == 'helm' then
                require 'lspconfig'.yamlls.setup {
                    diagnostics = false,
                }
            end
        end,
        settings = {
            trace = {
                server = 'debug',
            },
            yaml = {
                schemas = { kubernetes = '/*.yaml', },
            },
            schemaDownload = { enable = true, },
            validate = true,
        },
    }

    require 'lspconfig'.azure_pipelines_ls.setup {
        settings = {
            yaml = {
                schemas = {
                    ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
                        '**.yml',
                    },
                },
            },
        },
    }

    -- https://rust-analyzer.github.io/manual.html#nvim-lsp
    require 'lspconfig'.rust_analyzer.setup {
        settings = {
            ['rust-analyzer'] = {
                imports = {
                    granularity = {
                        group = 'module',
                    },
                    prefix = 'self',
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true,
                },
                checkOnSave = {
                    command = 'clippy',
                },
            },
        },
    }

    -- disable inline diagnostic message
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    })
end

return M
