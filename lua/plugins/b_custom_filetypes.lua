local M = {}

function M.setup()
    -- Custom file types
    local api = vim.api
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        {
            pattern = { '*.yml', },
            callback = function()
                api.nvim_set_option_value('filetype', 'azp', { buf = 0, })
                vim.cmd ':set syn=yaml'
                vim.cmd ':set comments=:#'
                vim.cmd ':set commentstring=#\\ %s'
            end,
        }
    )
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        {
            pattern = { '*/manifests/*.yaml', '*/resources/*.yaml', },
            callback = function()
                api.nvim_set_option_value('filetype', 'k8s', { buf = 0, })
                vim.cmd ':set syn=yaml'
                vim.cmd ':set comments=:#'
                vim.cmd ':set commentstring=#\\ %s'
            end,
        }
    )
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        {
            pattern = { '*/templates/*.yaml', '*/templates/*.tpl', 'values.yaml', 'values*.yaml', },
            callback = function()
                api.nvim_set_option_value('filetype', 'helm', { buf = 0, })
                vim.cmd ':set syn=yaml'
                vim.cmd ':set comments=:#'
                vim.cmd ':set commentstring=#\\ %s'
            end,
        }
    )
end

return M
