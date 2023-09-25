local M = {}

function M.setup()
    local hostname = require 'settings'.hostname
    local ts_languages = {}

    if string.find(hostname, 'farm-net') then
        table.insert(ts_languages, 'bash')
        table.insert(ts_languages, 'dockerfile')
        table.insert(ts_languages, 'python')
        table.insert(ts_languages, 'lua')
        table.insert(ts_languages, 'hcl')
        table.insert(ts_languages, 'vim')
        table.insert(ts_languages, 'yaml')
        table.insert(ts_languages, 'rust')
        table.insert(ts_languages, 'go')
    end

    if string.find(hostname, 'archtab') then
        table.insert(ts_languages, 'bash')
        table.insert(ts_languages, 'lua')
        table.insert(ts_languages, 'rust')
    end

    if string.find(hostname, '012') then
        table.insert(ts_languages, 'lua')
        table.insert(ts_languages, 'dart')
        table.insert(ts_languages, 'xml')
        table.insert(ts_languages, 'html')
        table.insert(ts_languages, 'css')
    end

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
