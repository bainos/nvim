local M = {}

-- Helper function to print debug messages
local function debug(msg)
    vim.api.nvim_echo({ { '[LSP Config]: ' .. msg, 'WarningMsg', }, }, true, {})
end

function M.setup()
    -- DEBUG: Check what's actually starting LSP servers

    local lsp_servers = {
        'bashls',
        'lua_ls',
        'rust_analyzer',
        'dockerls',
        'terraformls',
        'azure_pipelines_ls',
        'pyright',
        'marksman',
        'helm_ls',
    }

    require 'mason-lspconfig'.setup {
        ensure_installed = lsp_servers,
        automatic_installation = false,
        handlers = {},
    }

    vim.diagnostic.config {
        signs = {
            -- DEPRECATED 2024-03-27
            -- severity_limit = 'Warning',
            min = 'Warning',
        },
        underline = true,
        virtual_text = false,
        update_in_insert = false,
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    local lsp_servers_opt = {
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        root_dir = function(fname)
            return vim.fn.getcwd()
        end,
    }

    local lsp_servers_extra_opt = {
        bashls = { filetypes = { 'bash', 'sh', 'zsh', }, },
        pyright = {},
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
        azure_pipelines_ls = {
            filetypes = { 'yaml.azure-pipelines', },
        },
        rust_analyzer = {
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = {
                        command = 'clippy',
                    },
                },
            },
        },
    }

    local lspconfig = require 'lspconfig'

    for _, server in pairs(lsp_servers) do
        local extended_opts = vim.tbl_deep_extend('force', lsp_servers_opt, lsp_servers_extra_opt[server] or {})
        lspconfig[server].setup(extended_opts)
    end
end

return M
