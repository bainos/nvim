local M = {}

function M.setup()
    --local bufopts = { noremap=true, silent=true, buffer=bufnr }
    local opts = { noremap = true, silent = true, }

    -- code actions
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>fr', function() vim.lsp.buf.format { async = true, } end, opts)

    -- search
    vim.keymap.set('n', '<C-b>', ':noh<cr>:call clearmatches()<cr>', {})
    vim.keymap.set('n', '*', '*N', {})

    -- buffers
    vim.keymap.set('n', '<Leader>w', ':wa<cr>', {})
    vim.keymap.set('n', '<Leader>q', ':qa<cr>', {})
    vim.keymap.set('n', '<Leader>#', ':b#<cr>', {})

    -- toggle line numers
    vim.keymap.set('n', '<Leader>l', ':set number!<cr>', {})

    -- diagnostic
    local lsp_diagnostic = vim.diagnostic
    vim.keymap.set('n', '<Leader>d', lsp_diagnostic.open_float, {})
    vim.keymap.set('n', '<Leader>n', lsp_diagnostic.goto_next, {})
    vim.keymap.set('n', '<Leader>p', lsp_diagnostic.goto_prev, {})

    -- file/buffer manager
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<Leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})

    -- autocmd
    local function buf_format()
        vim.lsp.buf.format()
    end

    local api = vim.api
    api.nvim_create_autocmd(
        { 'BufWritePre', },
        --{ command = 'lua vim.lsp.buf.format()' }
        { callback = buf_format, }
    )
end

return M
