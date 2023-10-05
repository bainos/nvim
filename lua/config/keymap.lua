local M = {}

function M.setup()
    --local bufopts = { noremap=true, silent=true, buffer=bufnr }
    local opts = { noremap = true, silent = true, }

    -- code actions
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)

    -- formatter
    local formatter = require 'config.formatter'
    vim.api.nvim_create_user_command('Format', formatter.buf_format, { nargs = '?', })
    vim.keymap.set('n', '<Leader>fr', formatter.buf_format, opts)

    -- search
    vim.keymap.set('n', '<C-b>', ':noh<cr>:call clearmatches()<cr>', { desc = 'clear search matches', })
    vim.keymap.set('n', '*', '*N', opts)

    -- buffers
    vim.keymap.set('n', '<Leader>w', ':wa<cr>', { desc = 'write all', })
    vim.keymap.set('n', '<Leader>q', ':qa<cr>', { desc = 'quit all', })
    vim.keymap.set('n', '<Leader>#', ':b#<cr>', { desc = 'last buffer', })

    -- toggle line numers
    vim.keymap.set('n', '<Leader>l', ':set number!<cr>', { desc = 'toggle line numbers', })

    -- diagnostic
    local lsp_diagnostic = vim.diagnostic
    vim.keymap.set('n', '<Leader>d', lsp_diagnostic.open_float, { desc = 'diagnostic open float', })
    vim.keymap.set('n', '<Leader>n', lsp_diagnostic.goto_next, { desc = 'diagnostic next', })
    vim.keymap.set('n', '<Leader>p', lsp_diagnostic.goto_prev, { desc = 'diagnostic previus', })

    -- file/buffer manager
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'show files', })
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'grep files', })
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'show buffers', })
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'show help tags', })
    vim.keymap.set('n', '<Leader>fm', ':lua MiniFiles.open()<cr>', { desc = 'file browser', })
    vim.keymap.set('n', '<Leader>fn', ':Telescope notify<cr>', { desc = 'show notifications', })

    local save_session = function()
        vim.ui.input({ prompt = 'Create session in ' .. vim.fn.getcwd() .. '?', },
            function(input)
                if input == nil then return end
                vim.cmd ':mksession! .session.vim'
                print('session saved: ' .. vim.fn.getcwd() .. '/.session.vim')
            end
        )
    end

    vim.keymap.set('n', '<Leader>s', save_session, { desc = 'mksession', })
    vim.keymap.set('n', '<Leader>bn', ':bnext<cr>', { desc = 'next buf', })
    vim.keymap.set('n', '<Leader>bp', ':bprevious<cr>', { desc = 'next buf', })

    -- autocmd
    local api = vim.api
    api.nvim_create_autocmd(
        { 'BufWritePre', },
        --{ command = 'lua vim.lsp.buf.format()' }
        { callback = formatter.buf_format, }
    )
end

return M
