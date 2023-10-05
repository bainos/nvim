local M = {}

function M.setup()
    local hostname = require 'settings'.hostname()
    local formatters = {}

    if string.find(hostname, 'farm-net', 1, true) then
        table.insert(formatters, 'shfmt')
        table.insert(formatters, 'prettier') -- yaml
    end

    if string.find(hostname, 'archtab') then
        table.insert(formatters, 'shfmt')
    end

    if string.find(hostname, '012') then
        table.insert(formatters, 'prettier') -- js
    end

    require 'mason-tool-installer'.setup {
        ensure_installed = formatters,
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 5,
    }
end

local function shfmt(file_path)
    vim.cmd(':! shfmt -i 2 -ci -kp -s -w ' .. file_path)
end

local prettierrc = vim.fn.stdpath 'config' .. '/prettierrc'
local function prettier(file_path)
    vim.cmd(':! prettier --write --config ' .. prettierrc .. ' ' .. file_path)
end

local custom_formatters = {
    sh = shfmt,
    bash = shfmt,
    zsh = shfmt,
    javascript = prettier,
    markdown = prettier,
    javascriptreact = prettier,
    k8s = prettier,
    helm = prettier,
    yaml = prettier,
}

function M.buf_format()
    print('Formatting ', vim.bo.filetype, ': ', vim.api.nvim_buf_get_name(0))
    if custom_formatters[vim.bo.filetype] then
        custom_formatters[vim.bo.filetype](vim.api.nvim_buf_get_name(0))
        vim.cmd ':lua MiniTrailspace.trim()'
        vim.cmd ':lua MiniTrailspace.trim_last_lines()'
    else
        vim.lsp.buf.format()
    end
end

return M
