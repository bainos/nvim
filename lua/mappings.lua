local M = {}

function M.setup()
    --local bufopts = { noremap=true, silent=true, buffer=bufnr }
    local opts = { noremap = true, silent = true, }

    -- code actions
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>fr', function() vim.lsp.buf.format { async = true, } end, opts)

    -- TAB completion
    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
    end

    local luasnip = require 'luasnip'
    local cmp = require 'cmp'

    opts.mapping = vim.tbl_extend('force', opts, {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- this way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's', }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's', }),
    })

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
        -- needs ntpeters/vim-better-whitespace plugin
        vim.cmd ':StripWhitespace'
    end

    local api = vim.api
    api.nvim_create_autocmd(
        { 'BufWritePre', },
        --{ command = 'lua vim.lsp.buf.format()' }
        { callback = buf_format, }
    )
end

return M
