local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print('lazy plugin manager not found: installing it at path:')
  print(lazypath)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    "--depth=1",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require 'settings'.setup()
require 'lazy-plugins'.setup()
require 'highlight-parse'.setup()
require 'completion'.setup()
require 'lsp-config'.setup()
require 'lsp-null-ls'.setup()
require 'mappings'.setup()
require 'themes'.setup()
