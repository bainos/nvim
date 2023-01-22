local M = {}

function M.setup()
  local packer_conf = {
    profile = {
      enable = true,
      threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  }

  local function plugins(use)
    use 'wbthomason/packer.nvim'

    -- common
    use 'andymass/vim-matchup' -- matching parens and more
    use 'bronson/vim-trailing-whitespace' -- highlight trailing spaces
    use "nvim-lua/plenary.nvim"
		--use "lewis6991/impatient.nvim"

    -- general dev
    use 'neovim/nvim-lspconfig'
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    -- -- completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    -- -- highlighting
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    -- -- comments - <leader>c<space>
    use 'scrooloose/nerdcommenter' -- commenting shortcuts
    -- -- parens and quotes
    use "windwp/nvim-autopairs"

    -- search - buffer/file browser
    use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }

    -- python
    use { 'Vimjas/vim-python-pep8-indent', ft = 'python' }

    -- themes
    use "ellisonleao/gruvbox.nvim"
  end

  local packer = require("packer")

  -- Performance
  --pcall(require, "impatient")
  -- pcall(require, "packer_compiled")

  packer.init(packer_conf)
  packer.startup(plugins)
end

return M
