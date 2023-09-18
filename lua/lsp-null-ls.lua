local M = {}

function M.setup()
    local hostname = os.getenv 'HOST'
        or os.getenv 'HOSTNAME'
        or 'UNKOWN'

    local null_servers = { 'shfmt', }

    if string.find(hostname, 'farm-net') then
        table.insert(null_servers, 'prettierd') -- yaml
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
            null_ls.builtins.formatting.prettierd.with { filetypes = { 'yaml', 'helm', 'k8s', 'azp', }, },
        },
    }

    --require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.
end

return M
