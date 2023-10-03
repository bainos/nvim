local M = {}

function M.setup()
    local hostname = require 'settings'.hostname()
    local lsp_servers = {}

    if string.find(hostname, 'farm-net', 1, true) then
        table.insert(lsp_servers, 'bashls')
        table.insert(lsp_servers, 'lua_ls')
        table.insert(lsp_servers, 'rust_analyzer')
        table.insert(lsp_servers, 'dockerls')
        table.insert(lsp_servers, 'terraformls')
        table.insert(lsp_servers, 'azure_pipelines_ls')
        table.insert(lsp_servers, 'ruff_lsp')
        table.insert(lsp_servers, 'pyright')
        table.insert(lsp_servers, 'yamlls')
        table.insert(lsp_servers, 'marksman')
    end

    if string.find(hostname, 'archtab') then
        table.insert(lsp_servers, 'bashls')
        table.insert(lsp_servers, 'lua_ls')
        table.insert(lsp_servers, 'rust_analyzer')
    end

    if string.find(hostname, '012') then
        table.insert(lsp_servers, 'lua_ls')
        table.insert(lsp_servers, 'html')
        table.insert(lsp_servers, 'cssls')
        table.insert(lsp_servers, 'volar')
    end

    require 'mason-lspconfig'.setup {
        ensure_installed = lsp_servers,
        automatic_installation = false,
    }

    local diagnostic_config = {
        signs = {
            severity_limit = 'Warning',
        },
        underline = true,
        virtual_text = false,
        update_in_insert = false,
    }

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)

    local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    local lsp_servers_opt = {
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
    }

    local lsp_servers_extra_opt = {
        bashls = { filetypes = { 'bash', 'sh', 'zsh', }, },
        pyright = {
            handlers = {
                ['textDocument/publishDiagnostics'] = function(...)
                end,
            },
        },
        ruff_lsp = {
            init_options = {
                settings = {
                    -- Any extra CLI arguments for `ruff` go here.
                    args = {},
                },
            },
        },
        lua_ls = {
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
                },
            },
        },
        helm_ls = {
            filetypes = { 'helm', },
            cmd = { 'helm_ls', 'serve', },
        },
        yamlls = {
            filetypes = { 'k8s', },
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
        },
        azure_pipelines_ls = {
            settings = {
                yaml = {
                    schemas = {
                        ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
                            '**.yml',
                        },
                    },
                },
            },
        },
        rust_analyzer = {
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
        },
        html = {
            filetypes = { 'html', },
        },
        volar = {
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json', },
        },
    }

    local lspconfig = require 'lspconfig'

    for _, server in pairs(lsp_servers) do
        local extended_opts = vim.tbl_deep_extend('force', lsp_servers_opt, lsp_servers_extra_opt[server] or {})
        lspconfig[server].setup(extended_opts)
    end
end

return M
