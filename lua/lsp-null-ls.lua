local M = {}

function M.setup()
    local hostname = require 'settings'.hostname
    local null_servers = {}

    if string.find(hostname, 'farm-net') then
        table.insert(null_servers, 'shfmt')
        table.insert(null_servers, 'prettierd') -- yaml
    end

    if string.find(hostname, 'archtab') then
        table.insert(null_servers, 'shfmt')
        table.insert(null_servers, 'prettierd') -- yaml
    end

    if string.find(hostname, '012') then
        table.insert(null_servers, 'prettierd') -- js
    end

    -- language servers manager
    require 'mason'.setup()
    require 'mason-null-ls'.setup {
        ensure_installed = null_servers,
        automatic_installation = false,
        --automatic_setup = true, -- Recommended, but optional
    }

    local null_ls = require 'null-ls'
    null_ls.setup {
        sources = {
            -- common
            --{
            --null_ls.builtins.code_actions.refactoring,
            --filetypes = { 'lua', 'python', 'bash', 'sh', 'zsh', 'rust', },
            --},
            -- bash|sh|zsh
            null_ls.builtins.formatting.shfmt.with {
                extra_args = { '-i', '2', '-ci', '-kp', '-s', },
                filetypes = { 'bash', 'sh', 'zsh', },
            },
            null_ls.builtins.formatting.prettierd.with { filetypes = { 'yaml', 'helm', 'k8s', 'azp', 'javascript',
                'javascriptreact', }, },
        },
    }

    --require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.
end

return M
