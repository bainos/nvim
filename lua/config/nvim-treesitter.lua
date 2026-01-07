local M = {}

function M.setup()
    local ts_languages = {
        'regex',
        'bash',
        'dockerfile',
        'python',
        'lua',
        'hcl',
        'vim',
        'yaml',
        'rust',
        'go'
    }

    require 'nvim-treesitter.configs'.setup {
        modules = {},
        auto_install = false,
        sync_install = true,
        ignore_install = {},

        highlight = {
            enable = true,
        },
        ensure_installed = ts_languages,
    }
end

return M
