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

    vim.api.nvim_create_user_command('Format',
        function()
            local file_name = vim.api.nvim_buf_get_name(0)
            if vim.bo.filetype == 'sh'
                or vim.bo.filetype == 'bash'
                or vim.bo.filetype == 'zsh' then
                vim.cmd(':! shfmt -i 2 -ci -kp -s -w ' .. file_name)
            elseif vim.bo.filetype == 'javascript'
                or vim.bo.filetype == 'javascriptreact'
                or vim.bo.filetype == 'yaml' then
                vim.cmd(':! prettier --write --single-quote --jsx-single-quote ' .. file_name)
            else
                vim.lsp.buf.format()
            end
        end,
        { nargs = '?', }
    )
end

return M
