local M = {}

function M.setup()
    local hostname = require 'settings'.hostname()
    local lsp_servers = {}
    local lsp_linters = {}

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
        -- linters
        table.insert(lsp_linters, 'shfmt')
        table.insert(lsp_linters, 'prettierd') -- yaml
    end

    if string.find(hostname, 'archtab') then
        table.insert(lsp_servers, 'bashls')
        table.insert(lsp_servers, 'lua_ls')
        table.insert(lsp_servers, 'rust_analyzer')
        -- linters
        table.insert(lsp_linters, 'shfmt')
    end

    if string.find(hostname, '012') then
        table.insert(lsp_servers, 'lua_ls')
        table.insert(lsp_servers, 'html')
        table.insert(lsp_servers, 'cssls')
        table.insert(lsp_servers, 'volar')
        -- linters
        table.insert(lsp_linters, 'prettierd') -- js
    end

    -- language servers manager
    require 'mason'.setup {}
    require 'mason-lspconfig'.setup {
        ensure_installed = lsp_servers,
        automatic_installation = false,
    }

    --    formatters
    --    require 'lspconfig'.shfmt.setup {
    --        capabilities = capabilities,
    --        extra_args = { '-i', '2', '-ci', '-kp', '-s', },
    --        filetypes = { 'bash', 'sh', 'zsh', },
    --    }
    --
    --    require 'lspconfig'.prettierd.setup {
    --        capabilities = capabilities,
    --        filetypes = { 'yaml', 'helm', 'k8s', 'azp', 'javascript',
    --            'javascriptreact', },
    --    }

    local function _formatting(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
            local function format()
                local view = vim.fn.winsaveview()
                vim.lsp.buf.format {
                    async = true,
                    filter = function(attached_client)
                        return attached_client.name ~= ''
                    end,
                }
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.fn.winrestview(view)
            end

            local lsp_format_grp = vim.api.nvim_create_augroup('LspFormat', { clear = true, })
            vim.api.nvim_create_autocmd('BufWritePre', {
                callback = function()
                    vim.schedule(format)
                end,
                group = lsp_format_grp,
                buffer = bufnr,
            })
        end
    end

    local function _on_attach(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.MiniCompletion.completefunc_lsp')
        vim.api.nvim_buf_set_option(bufnr, 'completefunc', 'v:lua.MiniCompletion.completefunc_lsp')

        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
        if client.server_capabilities.definitionProvider then
            vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
        end

        _formatting(client, bufnr)
        -- signature_help(client, bufnr)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities.textDocument.completion.completionItem.snippetSupport = true

    local lsp_servers_opt = {
        on_attach = _on_attach,
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
            filetypes = { 'html', 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact',
                'typescript.tsx', },
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

    -- -- -- -- -- --
    -- require 'lspconfig'.marksman.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    -- }
    --
    -- require 'lspconfig'.bashls.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     filetypes = { 'bash', 'sh', 'zsh', },
    -- }
    --
    -- -- npm install -g dockerfile-language-server-nodejs
    -- require 'lspconfig'.dockerls.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    -- }
    --
    -- -- Python
    -- -- https://github.com/microsoft/pyright
    -- require 'lspconfig'.pyright.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     handlers = {
    --         ['textDocument/publishDiagnostics'] = function(...)
    --         end,
    --     },
    -- }
    --
    -- -- Python
    -- -- https://github.com/charliermarsh/ruff-lsp
    -- require 'lspconfig'.ruff_lsp.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     init_options = {
    --         settings = {
    --             -- Any extra CLI arguments for `ruff` go here.
    --             args = {},
    --         },
    --     },
    -- }
    --
    -- -- Lua
    -- -- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line
    -- local runtime_path = vim.split(package.path, ';')
    -- table.insert(runtime_path, 'lua/?.lua')
    -- table.insert(runtime_path, 'lua/?/init.lua')
    --
    -- require 'lspconfig'.lua_ls.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     settings = {
    --         Lua = {
    --             runtime = {
    --                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
    --                 version = 'LuaJIT',
    --                 -- Setup your lua path
    --                 path = runtime_path,
    --             },
    --             diagnostics = {
    --                 globals = { 'vim', 'use', 'bufnr', },
    --             },
    --             workspace = {
    --                 -- Make the server aware of Neovim runtime files
    --                 library = vim.api.nvim_get_runtime_file('', true),
    --                 checkThirdParty = false,
    --             },
    --             --format = { enable = false },
    --             format = {
    --                 enable = true,
    --                 -- Put format options here
    --                 -- NOTE: the value should be STRING!!
    --                 defaultConfig = {
    --                     indent_style = 'space',
    --                     indent_size = '4',
    --                 },
    --             },
    --         },
    --     },
    -- }
    --
    -- -- Terraform
    -- -- https://github.com/hashicorp/terraform-ls/releases
    -- require 'lspconfig'.terraformls.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    -- }
    --
    -- -- Helm
    -- -- https://github.com/mrjosh/helm-ls
    -- -- curl -L https://github.com/mrjosh/helm-ls/releases/download/master/helm_ls_linux_amd64 --output $HOME/.local/bin/helm_ls
    -- local configs = require 'lspconfig.configs'
    -- local lspconfig = require 'lspconfig'
    -- local util = require 'lspconfig.util'
    --
    -- if not configs.helm_ls then
    --     configs.helm_ls = {
    --         default_config = {
    --             cmd = { 'helm_ls', 'serve', },
    --             filetypes = { 'helm', },
    --             root_dir = function(fname)
    --                 return util.root_pattern 'Chart.yaml' (fname)
    --             end,
    --         },
    --     }
    -- end
    --
    -- lspconfig.helm_ls.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     filetypes = { 'helm', },
    --     cmd = { 'helm_ls', 'serve', },
    -- }
    --
    -- -- YAML
    -- require 'lspconfig'.yamlls.setup {
    --     --on_attach = function()
    --     --if vim.bo.buftype ~= '' or vim.bo.filetype == 'helm' then
    --     --require 'lspconfig'.yamlls.setup {
    --     --diagnostics = false,
    --     --}
    --     --end
    --     --end,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     on_attach = function(client, bufnr)
    --         _on_attach(client, bufnr)
    --         vim.bo.syn = 'yaml'
    --     end,
    --     filetypes = { 'k8s', },
    --     settings = {
    --         trace = {
    --             server = 'debug',
    --         },
    --         yaml = {
    --             schemas = { kubernetes = '/*.yaml', },
    --         },
    --         schemaDownload = { enable = true, },
    --         validate = true,
    --     },
    -- }
    --
    -- -- Azure Pipelines
    -- require 'lspconfig'.azure_pipelines_ls.setup {
    --     filetypes = { 'azp', },
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     on_attach = function()
    --         _on_attach()
    --         vim.bo.syn = 'yaml'
    --     end,
    --     settings = {
    --         yaml = {
    --             schemas = {
    --                 ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
    --                     '**.yml',
    --                 },
    --             },
    --         },
    --     },
    -- }
    --
    -- -- https://rust-analyzer.github.io/manual.html#nvim-lsp
    -- require 'lspconfig'.rust_analyzer.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     settings = {
    --         ['rust-analyzer'] = {
    --             imports = {
    --                 granularity = {
    --                     group = 'module',
    --                 },
    --                 prefix = 'self',
    --             },
    --             cargo = {
    --                 buildScripts = {
    --                     enable = true,
    --                 },
    --             },
    --             procMacro = {
    --                 enable = true,
    --             },
    --             checkOnSave = {
    --                 command = 'clippy',
    --             },
    --         },
    --     },
    -- }
    --
    -- require 'lspconfig'.html.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     filetypes = { 'html', 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact',
    --         'typescript.tsx', },
    -- }
    -- require 'lspconfig'.cssls.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --
    -- }
    -- require 'lspconfig'.volar.setup {
    --     on_attach = _on_attach,
    --     capabilities = capabilities,
    --     flags = {
    --         debounce_text_changes = 150,
    --     },
    --     filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json', },
    -- }

    -- disable inline diagnostic message
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    })
end

return M
