local M = {}

function M.setup()
    -- Azure Pipelines: *.yml files
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', }, {
        pattern = '*.yml',
        callback = function(ev)
            vim.bo[ev.buf].filetype = 'yaml.azure-pipelines'
        end,
    })

    -- Kubernetes: manifests in resources/ folders (*.yaml)
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', }, {
        pattern = '*/resources/*.yaml',
        callback = function(ev)
            vim.bo[ev.buf].filetype = 'yaml.kubernetes'
        end,
    })

    -- Helm Values: files starting with "values" (*.yaml)
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', }, {
        pattern = 'values*.yaml',
        callback = function(ev)
            vim.bo[ev.buf].filetype = 'yaml.helm-values'
        end,
    })

    -- Helm Templates: files in templates/ folders (*.yaml, *.tpl)
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', }, {
        pattern = { '*/templates/*.yaml', '*/templates/*.tpl', },
        callback = function(ev)
            vim.bo[ev.buf].filetype = 'helm'
        end,
    })

    -- Markdown: enable word wrap
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', }, {
        pattern = { '*.md', '*.markdown', },
        callback = function()
            vim.schedule(function()
                vim.wo.wrap = true
            end)
        end,
    })
end

return M
