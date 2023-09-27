local M = {}

function M.setup()
    local hostname = require 'settings'.hostname()
    local plugins = {
        { 'folke/lazy.nvim',        version = '*', },
        -- common
        --'nvim-lua/plenary.nvim',
        { 'mg979/vim-visual-multi', lazy = false, },
        {
            'folke/which-key.nvim',
            lazy = false,
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
        --{
        --'nvim-lualine/lualine.nvim',
        --dependencies = { 'nvim-tree/nvim-web-devicons', },
        --opts = { theme = 'gruvebox-material', },
        --event = 'VeryLazy',
        --},
        -- general dev
        -- lsp-config
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim', },
        },
        -- mini
        { 'echasnovski/mini.nvim',       version = '*', lazy = false, },
        { 'echasnovski/mini.comment',    version = '*', lazy = false, },
        { 'echasnovski/mini.completion', version = '*', event = 'InsertEnter', },
        { 'echasnovski/mini.files',      version = '*', lazy = false, },
        { 'echasnovski/mini.pairs',      version = '*', event = 'InsertEnter', },
        { 'echasnovski/mini.sessions',   version = '*', lazy = false, },
        { 'echasnovski/mini.statusline', version = '*', event = 'VeryLazy', },
        { 'echasnovski/mini.surround',   version = '*', event = 'InsertEnter', },
        { 'echasnovski/mini.trailspace', version = '*', lazy = false, },

        -- -- completion
        --{
        --'hrsh7th/nvim-cmp',
        --event = 'InsertEnter',
        --dependencies = {
        --'hrsh7th/cmp-nvim-lsp',
        --'hrsh7th/cmp-buffer',
        --'hrsh7th/cmp-path',
        --'hrsh7th/cmp-cmdline',
        --'saadparwaiz1/cmp_luasnip',
        --},
        --},
        -- Use <tab> for completion and snippets (supertab)
        -- first: disable default <tab> and <s-tab> behavior in LuaSnip
        -- {
        --     'L3MON4D3/LuaSnip',
        --     --keys = function()
        --     --return {}
        --     --end,
        -- },
        -- search - buffer/file browser
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                -- 'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons',
            },
        },
        -- -- highlighting
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', },
        -- themes
        {
            'ellisonleao/gruvbox.nvim',
            lazy = false,
            priority = 1000,
        },
        -- experimental
        {
            'folke/noice.nvim',
            event = 'VeryLazy',
            opts = {
                -- add any options here
            },
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                'MunifTanjim/nui.nvim',
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                -- 'rcarriga/nvim-notify',
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
            -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
            -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
            --lazy = false,
            lazy = true,
            -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
            -- have outdated releases, which may break your Neovim install.
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
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

    require 'mini.comment'.setup()
    require 'mini.completion'.setup
    {
        delay = { completion = 200, info = 100, signature = 50, },

        -- Way of how module does LSP completion
        lsp_completion = {
            source_func = 'omnifunc',
            auto_setup = false,
        },

        -- Module mappings. Use `''` (empty string) to disable one. Some of them
        -- might conflict with system mappings.
        mappings = {
            force_twostep = '<C-Space>',  -- Force two-step completion
            force_fallback = '<A-Space>', -- Force fallback completion
        },

        set_vim_settings = true,
    }
    require 'mini.files'.setup()
    require 'mini.fuzzy'.setup()
    require 'mini.pairs'.setup()
    require 'mini.sessions'.setup {
        -- Whether to read latest session if Neovim opened without file arguments
        autoread = false,
        -- Whether to write current session before quitting Neovim
        autowrite = true,
        directory = 'session',
        file = 'Session.vim',
    }
    require 'mini.statusline'.setup()
    require 'mini.surround'.setup()
    require 'mini.trailspace'.setup()

    require 'noice'.setup {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
                ['cmp.entry.get_documentation'] = true,
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
    }

    if string.find(hostname, '012') then
        require 'flutter-tools'.setup {
            -- config
        }
    end
end

return M
