local M = {}

function M.setup()
    --local bufopts = { noremap=true, silent=true, buffer=bufnr }
    -- local opts = { noremap = true, silent = true, }

    -- code actions
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'code actions', })

    -- formatter
    local formatter = require 'plugins.b_formatter'
    vim.api.nvim_create_user_command('Format', formatter.buf_format, { nargs = '?', })
    vim.keymap.set('n', '<Leader>fr', formatter.buf_format, { noremap = true, silent = true, desc = 'format buffer', })
    vim.keymap.set('n', '<Leader>tr', ':lua MiniTrailspace.trim()<cr>', { noremap = true, silent = true, desc = 'trim trailing spaces', })

    -- search
    vim.keymap.set('n', '<C-b>', ':noh<cr>:call clearmatches()<cr>', { noremap = true, silent = true, desc = 'clear search matches', })
    -- vim.keymap.set('n', '*', '*N', opts)

    -- buffers
    vim.keymap.set('n', '<Leader>w', ':wa<cr>', { noremap = true, silent = true, desc = 'write all', })
    vim.keymap.set('n', '<Leader>q', ':qa<cr>', { noremap = true, silent = true, desc = 'quit all', })
    vim.keymap.set('n', '<Leader>#', ':b#<cr>', { noremap = true, silent = true, desc = 'last buffer', })

    -- toggle line numers
    vim.keymap.set('n', '<Leader>l', ':set number!<cr>', { noremap = true, silent = true, desc = 'toggle line numbers', })

    -- diagnostic
    local lsp_diagnostic = vim.diagnostic
    vim.keymap.set('n', '<Leader>d', lsp_diagnostic.open_float, { noremap = true, silent = true, desc = 'diagnostic open float', })
    vim.keymap.set('n', '<Leader>n', lsp_diagnostic.goto_next, { noremap = true, silent = true, desc = 'diagnostic next', })
    vim.keymap.set('n', '<Leader>p', lsp_diagnostic.goto_prev, { noremap = true, silent = true, desc = 'diagnostic previus', })

    -- file/buffer manager
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<Leader>ff', builtin.find_files, { noremap = true, silent = true, desc = 'show files', })
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { noremap = true, silent = true, desc = 'grep files', })
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, { noremap = true, silent = true, desc = 'show buffers', })
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { noremap = true, silent = true, desc = 'show help tags', })
    vim.keymap.set('n', '<Leader>fs', builtin.lsp_document_symbols, { noremap = true, silent = true, desc = 'show LSP symbols', })
    vim.keymap.set('n', '<Leader>fd', builtin.lsp_definitions, { noremap = true, silent = true, desc = 'show/go to definition', })
    vim.keymap.set('n', '<Leader>fm', ':lua MiniFiles.open()<cr>', { noremap = true, silent = true, desc = 'file browser', })
    -- vim.keymap.set('n', '<Leader>fn', ':Telescope notify<cr>', { noremap = true, silent = true, desc = 'show notifications', })

    vim.keymap.set('n', '<Leader>bn', ':bnext<cr>', { noremap = true, silent = true, desc = 'next buf', })
    vim.keymap.set('n', '<Leader>bp', ':bprevious<cr>', { noremap = true, silent = true, desc = 'next buf', })

    -- session
    local b_session = require 'plugins.b_session'
    vim.keymap.set('n', '<Leader>ss', b_session.save, { noremap = true, silent = true, desc = 'save session', })

    -- autocmd
    -- local api = vim.api
    -- api.nvim_create_autocmd(
    --     { 'BufWritePre', },
    --     --{ command = 'lua vim.lsp.buf.format()' }
    --     { callback = formatter.buf_format, }
    -- )
end

return M
