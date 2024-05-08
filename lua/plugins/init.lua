local M = {}

function M.setup()
    local hostname = require 'settings'.hostname()
    local plugins = {
        { 'folke/lazy.nvim',             version = '*', },
        { 'echasnovski/mini.nvim',       version = '*',   lazy = false, },
        { 'echasnovski/mini.comment',    version = '*',   lazy = false, },
        { 'echasnovski/mini.files',      version = '*',   lazy = false, },
        { 'echasnovski/mini.pairs',      version = '*',   event = 'InsertEnter', },
        { 'echasnovski/mini.statusline', version = '*',   event = 'VeryLazy', },
        { 'echasnovski/mini.surround',   version = '*',   event = 'InsertEnter', },
        { 'echasnovski/mini.tabline',    version = '*',   lazy = false, },
        { 'echasnovski/mini.trailspace', version = '*',   lazy = false, },
        { 'mg979/vim-visual-multi',      lazy = false, },
        { 'ellisonleao/gruvbox.nvim',    priority = 1000, },
        {
            'folke/which-key.nvim',
            lazy = false,
            config = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require 'which-key'.setup()
            end,
        },
        -- { 'rcarriga/nvim-notify', },
        -- {
        --     'folke/noice.nvim',
        --     event = 'VeryLazy',
        --     opts = {},
        --     dependencies = {
        --         'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify', },
        -- },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons',
            },
        },
        -- -- highlighting
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', tag = 'v0.9.1', },
        -- -- LSP
        { 'neovim/nvim-lspconfig', },
        {
            'williamboman/mason.nvim',
            dependencies = { 'williamboman/mason-lspconfig.nvim', },
        },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim', },
        -- -- completion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'saadparwaiz1/cmp_luasnip',
                'L3MON4D3/LuaSnip',
            },
        },
    }

    -- helm
    if string.find(hostname, 'farm-net', 1, true) then
        table.insert(plugins, 'towolf/vim-helm')
    end

    -- Flutter/Dart
    if string.find(hostname, '012') then
        table.insert(plugins, {
            'akinsho/flutter-tools.nvim',
            --lazy = false,
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            config = true,
        })
    end

    local opts = {
        defaults = {
            lazy = true,
            version = false,           -- always use the latest git commit
        },
        checker = { enabled = true, }, -- automatically check for plugin updates
        performance = {
            rtp = {
                -- disable some rtp plugins
                disabled_plugins = {
                    'gzip',
                    'matchit',
                    'matchparen',
                    'netrwPlugin',
                    'tarPlugin',
                    'tohtml',
                    'tutor',
                    'zipPlugin',
                },
            },
        },
    }

    require 'lazy'.setup(plugins, opts)
    require 'mason'.setup()

    require 'mini.comment'.setup()
    require 'mini.files'.setup
    {
        mappings = {
            close       = 'q',
            go_in       = '<Right>',
            go_in_plus  = 'L',
            go_out      = '<Left>',
            go_out_plus = 'H',
            reset       = '<BS>',
            reveal_cwd  = '@',
            show_help   = 'g?',
            synchronize = '=',
            trim_left   = '<',
            trim_right  = '>',
        },
    }

    require 'mini.pairs'.setup()
    require 'mini.statusline'.setup()
    require 'mini.surround'.setup()
    require 'mini.trailspace'.setup()
    require 'mini.tabline'.setup()

    ---@diagnostic disable-next-line: undefined-field
    -- require 'notify'.setup {
    --     stages = 'static',
    --     render = 'minimal',
    -- }

    -- b_plugins
    require 'plugins.b_custom_filetypes'.setup()
    require 'plugins.b_formatter'.setup()
    require 'plugins.b_session'.setup()
end

return M
