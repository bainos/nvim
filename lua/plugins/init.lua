local M = {}

function M.setup()
    local hostname = require 'settings'.hostname()
    local plugins = {
        { 'folke/lazy.nvim',             version = '*', },
        { 'echasnovski/mini.nvim',       version = '*',   lazy = false, },
        { 'echasnovski/mini.comment',    version = '*',   lazy = false, },
        { 'echasnovski/mini.files',      version = '*',   lazy = false, },
        -- { 'echasnovski/mini.pairs', version = '*', event = 'InsertEnter' },
        { 'echasnovski/mini.statusline', version = '*',   event = 'VeryLazy', },
        -- { 'echasnovski/mini.surround', version = '*', event = 'InsertEnter' },
        { 'echasnovski/mini.tabline',    version = '*',   lazy = false, },
        { 'echasnovski/mini.trailspace', version = '*',   lazy = false, },
        { 'mg979/vim-visual-multi',      lazy = false, },
        { 'ellisonleao/gruvbox.nvim',    priority = 1000, },
        {
            'folke/which-key.nvim',
            event = 'VeryLazy',
            opts = {
                preset = 'helix',
                delay = function() return 1000 end,
            },
            keys = {
                {
                    '<leader>?',
                    function() require 'which-key'.show { global = false, } end,
                    desc = 'Buffer Local Keymaps (which-key)',
                },
            },
        },
        -- { 'rcarriga/nvim-notify' },
        -- {
        --     'folke/noice.nvim',
        --     event = 'VeryLazy',
        --     opts = {},
        --     dependencies = {
        --         'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify',
        --     },
        -- },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons',
            },
        },
        {
            'andymass/vim-matchup',
            lazy = false,
            config = function()
                vim.g.matchup_matchparen_offscreen = { method = 'popup', }
            end,
        },
        {
            'nvim-treesitter/nvim-treesitter',
            dependencies = { 'andymass/vim-matchup', },
            build = ':TSUpdate',
            config = function()
                local configs = require 'nvim-treesitter.configs'
                configs.setup {
                    modules = {},
                    ignore_install = {},
                    auto_install = true,
                    ensure_installed = {
                        'bash', 'lua', 'vim', 'vimdoc', 'rust', 'yaml', 'python', 'hcl', 'markdown', 'json', 'dockerfile',
                    },
                    sync_install = true,
                    highlight = { enable = true, },
                    indent = { enable = true, },
                    matchup = { enable = true, },
                }
            end,
        },
        { 'neovim/nvim-lspconfig', },
        {
            'williamboman/mason.nvim',
            dependencies = { 'williamboman/mason-lspconfig.nvim', },
        },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim', },
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
        {
            'coder/claudecode.nvim',
            dependencies = { 'folke/snacks.nvim', },
            config = true,
            keys = {
                { '<leader>a',  nil,                              desc = 'AI/Claude Code', },
                { '<leader>ac', '<cmd>ClaudeCode<cr>',            desc = 'Toggle Claude', },
                { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       desc = 'Focus Claude', },
                { '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   desc = 'Resume Claude', },
                { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude', },
                { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       desc = 'Add current buffer', },
                { '<leader>as', '<cmd>ClaudeCodeSend<cr>',        mode = 'v',                  desc = 'Send to Claude', },
                {
                    '<leader>as',
                    '<cmd>ClaudeCodeTreeAdd<cr>',
                    desc = 'Add file',
                    ft = { 'NvimTree', 'neo-tree', 'oil', },
                },
                -- Diff management
                { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff', },
                { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = 'Deny diff', },
            },
        },
        -- {
        --     'greggh/claude-code.nvim',
        --     dependencies = {
        --         'nvim-lua/plenary.nvim', -- Required for git operations
        --     },
        --     -- config = function()
        --     --     require 'claude-code'.setup()
        --     -- end,
        -- },
        -- { import = 'plugins.copilotchat', },
        -- {
        --     'CopilotC-Nvim/CopilotChat.nvim',
        --     dependencies = {
        --         { 'github/copilot.vim' },
        --         { 'nvim-lua/plenary.nvim', branch = 'master' },
        --     },
        --     build = 'make tiktoken',
        --     opts = {},
        -- },
        -- {
        --     'hedyhli/outline.nvim',
        --     lazy = true,
        --     cmd = { 'Outline', 'OutlineOpen' },
        --     keys = {
        --         { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
        --     },
        --     opts = {},
        -- },
    }

    -- helm
    if string.find(hostname, 'farm-net', 1, true) then
        table.insert(plugins, 'towolf/vim-helm')
    end

    if vim.g.neovide then
        table.insert(plugins, 'towolf/vim-helm')
    end

    -- Flutter/Dart
    if string.find(hostname, '012') then
        table.insert(plugins, {
            'akinsho/flutter-tools.nvim',
            dependencies = { 'nvim-lua/plenary.nvim', },
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

    local function setup_mini_plugins()
        require 'mini.comment'.setup()
        require 'mini.files'.setup {
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
        require 'mini.statusline'.setup()
        require 'mini.surround'.setup()
        require 'mini.trailspace'.setup()
        require 'mini.tabline'.setup()
    end

    setup_mini_plugins()
    vim.g.claudecode_auto_setup = { auto_start = true }
    -- require 'claude-code'.setup()

    -- require 'nvim-treesitter.configs'.setup {
    --     matchup = {
    --         enable = true,
    --     },
    -- }

    -- require 'notify'.setup {
    --     stages = 'static',
    --     render = 'minimal',
    -- }

    -- b_plugins
    require 'plugins.b_custom_filetypes'.setup()
    require 'plugins.b_formatter'.setup()
    require 'plugins.b_session'.setup()
    -- require 'plugins.b_yank_mouse_restore'.setup()
end

return M
