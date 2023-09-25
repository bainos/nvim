local M = {}

function M.setup()
    local hostname = require 'settings'.hostname
    local plugins = {
        { 'folke/lazy.nvim',        version = '*', },
        -- common
        'nvim-lua/plenary.nvim',
        --{ 'ntpeters/vim-better-whitespace', lazy = false, },
        {
            'cappyzawa/trim.nvim',
            opts = {
                ft_blocklist = {},
                patterns = {},
                trim_on_write = false,
                trim_trailing = true,
                trim_last_line = false,
                trim_first_line = true,
            },
        },
        {
            'folke/persistence.nvim',
            event = 'BufReadPre', -- this will only start session saving when an actual file was opened
            opts = {
                -- add any custom options here
            },
        },
        { 'mg979/vim-visual-multi', lazy = false, },
        -- As of Neovim 0.9, this plugin is no longer required. Instead run:
        -- vim.loader.enable()
        --'lewis6991/impatient.nvim',
        --{
        --'dstein64/vim-startuptime',
        --cmd = 'StartupTime',
        --config = function()
        --vim.g.startuptime_tries = 10
        --end,
        --},
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
        -- lsp-config
        'neovim/nvim-lspconfig',
        'williamboman/mason-lspconfig.nvim',
        -- null-ls
        'jose-elias-alvarez/null-ls.nvim',
        'jay-babu/mason-null-ls.nvim',
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
        { 'scrooloose/nerdcommenter',        lazy = false, },
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
                'rcarriga/nvim-notify',
            },
        },
    }

    -- helm
    if string.find(hostname, 'farm-net') then
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

    require 'lualine'.setup {
        -- config
    }
    require 'flutter-tools'.setup {
        -- config
    }
    require 'telescope'.setup {
        -- config
        defaults = {
            file_ignore_patterns = { '.git', 'tmp', },
        },
    }
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
end

return M
