return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- common
  use 'andymass/vim-matchup' -- matching parens and more
  use 'bronson/vim-trailing-whitespace' -- highlight trailing spaces
  use "nvim-lua/plenary.nvim"

  -- general dev
  use 'neovim/nvim-lspconfig'
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  --use({
  --"glepnir/lspsaga.nvim",
  --branch = "main",
  --config = function()
  --require('lspsaga').setup({
  --error_sign = '!',
  --warn_sign = '^',
  --hint_sign = '?',
  --infor_sign = '~',
  --border_style = "round",
  --code_action_prompt = {
  --enable = false
  --}
  --})
  --end,
  --})
  use 'hrsh7th/nvim-compe'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'scrooloose/nerdcommenter' -- commenting shortcuts

  -- search
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }

  -- python
  use { 'Vimjas/vim-python-pep8-indent', ft = 'python' }

  -- themes
  use "ellisonleao/gruvbox.nvim"
end)
