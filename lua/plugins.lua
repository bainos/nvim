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
        use 'ntpeters/vim-better-whitespace'
        use 'nvim-lua/plenary.nvim'
        use 'mg979/vim-visual-multi'
        use 'lewis6991/impatient.nvim'
        use 'dstein64/vim-startuptime'
        use {
            'folke/which-key.nvim',
            config = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require 'which-key'.setup {
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                }
            end,
        }
        use {
            'glepnir/dashboard-nvim',
            event = 'VimEnter',
            config = function()
                require 'dashboard'.setup {
                    -- config
                }
            end,
            requires = { 'nvim-tree/nvim-web-devicons', },
        }
        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'nvim-tree/nvim-web-devicons', },
            --requires = { 'kyazdani42/nvim-web-devicons', opt = true, },
        }
        require 'lualine'.setup {
            -- config
        }

        -- general dev
        use 'williamboman/mason.nvim'
        -- -- lsp-config
        use 'neovim/nvim-lspconfig'
        use 'williamboman/mason-lspconfig.nvim'
        -- -- null-ls
        use 'jose-elias-alvarez/null-ls.nvim'
        use 'jay-babu/mason-null-ls.nvim'
        -- -- completion
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/cmp-vsnip'
        use 'saadparwaiz1/cmp_luasnip'
        -- -- snippet engines
        --use("hrsh7th/vim-vsnip")
        use { 'L3MON4D3/LuaSnip', tag = 'v1.*', }
        -- -- highlighting
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', }
        -- -- comments - <leader>c<space>
        use 'scrooloose/nerdcommenter' -- commenting shortcuts
        -- -- parens and quotes
        use 'windwp/nvim-autopairs'

        -- search - buffer/file browser
        use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim', }, { 'nvim-lua/plenary.nvim', }, }, }

        -- python
        -- use { 'Vimjas/vim-python-pep8-indent', ft = 'python', }

        -- helm
        use 'towolf/vim-helm'

        -- themes
        use 'ellisonleao/gruvbox.nvim'
    end

    local packer = require 'packer'

    -- Performance
    pcall(require, 'impatient')
    pcall(require, 'packer_compiled')

    packer.init(packer_conf)
    packer.startup(plugins)
end

return M
