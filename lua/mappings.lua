local M = {}

function M.setup()
  -- search
  vim.keymap.set('n', '<C-b>', ':noh<cr>:call clearmatches()<cr>', {})
  vim.keymap.set('n', '*', '*N', {})

  -- buffers
  vim.keymap.set('n', '<Leader>w', ':w<cr>', {})
  vim.keymap.set('n', '<Leader>qa', ':qa<cr>', {})
  vim.keymap.set('n', '<Leader>#', ':b#<cr>', {})

  -- diagnostic
  local lsp_diagnostic = vim.diagnostic
  vim.keymap.set('n', '<Leader>d', lsp_diagnostic.open_float, {})
  vim.keymap.set('n', '<Leader>n', lsp_diagnostic.goto_next, {})
  vim.keymap.set('n', '<Leader>p', lsp_diagnostic.goto_prev, {})

  -- file/buffer manager
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

  local function buf_format()
    vim.lsp.buf.format()
  end

  local api = vim.api
  api.nvim_create_autocmd(
    { "BufWritePre", },
    --{ command = 'lua vim.lsp.buf.format()' }
    { callback = buf_format }
  --{ callback = vim.lsp.buf.format }
  )
end

return M
