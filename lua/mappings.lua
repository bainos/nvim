vim.keymap.set('n', '<C-b>', ':noh<cr>:call clearmatches()<cr>', {})
vim.keymap.set('n', '<Leader>w', ':w<cr>', {})

local lsp_diagnostic = vim.diagnostic
vim.keymap.set('n', '<Leader>d', lsp_diagnostic.open_float, {})
vim.keymap.set('n', '<Leader>n', lsp_diagnostic.goto_next, {})
vim.keymap.set('n', '<Leader>p', lsp_diagnostic.goto_prev, {})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
