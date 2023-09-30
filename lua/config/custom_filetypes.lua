local M = {}

function M.setup()
    -- Custom file types
    local api = vim.api
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        {
            pattern = { '*.yml', },
            callback = function()
                api.nvim_buf_set_option(0, 'filetype', 'azp')
            end,
        }
    )
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        {
            pattern = { '*/manifests/*.yaml', '*/resources/*.yaml', },
            callback = function()
                api.nvim_buf_set_option(0, 'filetype', 'k8s')
            end,
        }
    )
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        {
            pattern = { '*/templates/*.yaml', '*/templates/*.tpl', 'values.yaml', 'values*.yaml', },
            callback = function()
                api.nvim_buf_set_option(0, 'filetype', 'helm')
            end,
        }
    )
end

return M
