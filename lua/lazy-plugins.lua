local M = {}

function M.setup()
    local plugins = {
        'LazyVim/LazyVim',
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
            opts = { theme = 'gruvebox-material', },
            event = 'VeryLazy',
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
            },
        },
        -- Use <tab> for completion and snippets (supertab)
        -- first: disable default <tab> and <s-tab> behavior in LuaSnip
        {
            'L3MON4D3/LuaSnip',
            --keys = function()
            --return {}
            --end,
        },
        -- -- highlighting
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', },
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

    local opts = {
        defaults = {
            -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
            -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
            lazy = false,
            -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
            -- have outdated releases, which may break your Neovim install.
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        checker = { enabled = true, }, -- automatically check for plugin updates
    }
    require 'lazy'.setup(plugins, opts)

    require 'lualine'.setup {
        -- config
    }

    -- Performance
    pcall(require, 'impatient')
end

return M
