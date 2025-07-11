local M = {}

function M.setup()

    -- code actions
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'code actions', })

    -- formatter
    vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, { desc = 'Format buffer with LSP' })
    vim.keymap.set('n', '<Leader>fr', vim.lsp.buf.format, { noremap = true, silent = true, desc = 'format buffer', })
    vim.keymap.set('n', '<Leader>tr', ':lua MiniTrailspace.trim()<cr>',
        { noremap = true, silent = true, desc = 'trim trailing spaces', })

    -- search
    vim.keymap.set('n', '<C-b>', ':noh<cr>:call clearmatches()<cr>',
        { noremap = true, silent = true, desc = 'clear search matches', })

    -- buffers
    vim.keymap.set('n', '<Leader>w', ':wa<cr>', { noremap = true, silent = true, desc = 'write all', })
    vim.keymap.set('n', '<Leader>q', ':qa<cr>', { noremap = true, silent = true, desc = 'quit all', })
    vim.keymap.set('n', '<Leader>#', ':b#<cr>', { noremap = true, silent = true, desc = 'last buffer', })

    -- toggle line numers
    vim.keymap.set('n', '<Leader>l', ':set number!<cr>', { noremap = true, silent = true, desc = 'toggle line numbers', })

    -- diagnostic
    local lsp_diagnostic = vim.diagnostic
    vim.keymap.set('n', '<Leader>d', lsp_diagnostic.open_float,
        { noremap = true, silent = true, desc = 'diagnostic open float', })
    vim.keymap.set('n', '<Leader>n', lsp_diagnostic.goto_next,
        { noremap = true, silent = true, desc = 'diagnostic next', })
    vim.keymap.set('n', '<Leader>p', lsp_diagnostic.goto_prev,
        { noremap = true, silent = true, desc = 'diagnostic previous', })

    -- file/buffer manager
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<Leader>ff', builtin.find_files, { noremap = true, silent = true, desc = 'show files', })
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { noremap = true, silent = true, desc = 'grep files', })
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, { noremap = true, silent = true, desc = 'show buffers', })
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { noremap = true, silent = true, desc = 'show help tags', })
    vim.keymap.set('n', '<Leader>fs', builtin.lsp_document_symbols,
        { noremap = true, silent = true, desc = 'show LSP symbols', })
    vim.keymap.set('n', '<Leader>fd', builtin.lsp_definitions,
        { noremap = true, silent = true, desc = 'show/go to definition', })
    vim.keymap.set('n', '<Leader>fm', ':lua MiniFiles.open()<cr>',
        { noremap = true, silent = true, desc = 'file browser', })
    
    -- YAML workflow-specific navigation
    vim.keymap.set('n', '<Leader>fk', function()
        builtin.find_files({ 
            prompt_title = "Kubernetes Manifests",
            find_command = { 'fdfind', '--type', 'f', '--extension', 'yaml', 'resources' }
        })
    end, { noremap = true, silent = true, desc = 'find Kubernetes manifests', })
    
    vim.keymap.set('n', '<Leader>fv', function()
        builtin.find_files({
            prompt_title = "Helm Values",
            find_command = { 'fdfind', '--type', 'f', '--glob', 'values*.yaml' }
        })
    end, { noremap = true, silent = true, desc = 'find Helm values files', })
    
    vim.keymap.set('n', '<Leader>fp', function()
        builtin.find_files({
            prompt_title = "Azure Pipelines",
            find_command = { 'fdfind', '--type', 'f', '--extension', 'yml' }
        })
    end, { noremap = true, silent = true, desc = 'find Azure Pipeline files', })
    vim.keymap.set('n', '<Leader>bn', ':bnext<cr>', { noremap = true, silent = true, desc = 'next buf', })
    vim.keymap.set('n', '<Leader>bp', ':bprevious<cr>', { noremap = true, silent = true, desc = 'previous buf', })

    if vim.g.neovide then
        vim.api.nvim_echo({ { 'This is Neovide! ' .. vim.g.neovide_version, "WarningMsg" } }, true, {})

        vim.opt.clipboard = "unnamedplus"
        vim.opt.mouse = 'a'

        -- Copy to system clipboard
        vim.api.nvim_set_keymap('n', '<C-S-c>', '"+y', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<C-S-c>', '"+y', { noremap = true, silent = true })

        -- Paste from system clipboard
        vim.api.nvim_set_keymap('n', '<C-S-v>', '"+p', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('i', '<C-S-v>', '<C-R>+', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('c', '<C-S-v>', '<C-R>+', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<C-S-v>', '<C-R>+', { noremap = true, silent = true })
    end

end

return M
