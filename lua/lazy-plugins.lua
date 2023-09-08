local M = {}

function M.setup()
    local plugins = {
        -- common
        'ntpeters/vim-better-whitespace',
        'nvim-lua/plenary.nvim',
        'mg979/vim-visual-multi',
        'lewis6991/impatient.nvim',
        'dstein64/vim-startuptime',
        {
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
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', },
        },
        -- general dev
        'williamboman/mason.nvim',
        -- -- lsp-config
        'neovim/nvim-lspconfig',
        'williamboman/mason-lspconfig.nvim',
        -- -- null-ls
        'jose-elias-alvarez/null-ls.nvim',
        'jay-babu/mason-null-ls.nvim',
        -- -- completion
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-vsnip',
                'saadparwaiz1/cmp_luasnip',
                -- snippet engines
                'L3MON4D3/LuaSnip',
            },
        },
        -- -- highlighting
        { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', },
        -- comments - <leader>c<space>
        'scrooloose/nerdcommenter',
        -- parens and quotes
        'windwp/nvim-autopairs',
        -- search - buffer/file browser
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
            },
        },
        -- helm
        'towolf/vim-helm',
        -- themes
        'ellisonleao/gruvbox.nvim',
        'one-dark/onedark.nvim',
        'jacoborus/tender.vim',
    }

    local opts = {}
    require 'lazy'.setup(plugins, opts)

    require 'lualine'.setup {
        -- config
    }

    -- Performance
    pcall(require, 'impatient')
end

return M
