function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

function cmap(shortcut, command)
  map('c', shortcut, command)
end

function tmap(shortcut, command)
  map('t', shortcut, command)
end

nmap('<C-b>', ':noh<cr>:call clearmatches()<cr>')
nmap('<Leader>d', ':lua vim.diagnostic.open_float()<CR>')
nmap('<Leader>n', ':lua vim.diagnostic.goto_next()<CR>')
nmap('<Leader>p', ':lua vim.diagnostic.goto_prev()<CR>')
