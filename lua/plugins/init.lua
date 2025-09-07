local M = {}

function M.setup()
    local plugins = {
        { 'folke/lazy.nvim',             version = '*', },
        { 'echasnovski/mini.nvim',       version = '*',   lazy = false, },
        { 'echasnovski/mini.comment',    version = '*',   lazy = false, },
        { 'echasnovski/mini.files',      version = '*',   lazy = false, },
        { 'echasnovski/mini.statusline', version = '*',   event = 'VeryLazy', },
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
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons',
            },
            config = function()
                require('telescope').setup({
                    defaults = {
                        prompt_prefix = "  ",
                        selection_caret = " ",
                        path_display = { "truncate" },
                    },
                    pickers = {
                        find_files = {
                            hidden = true,
                        },
                        live_grep = {
                            additional_args = function()
                                return {"--hidden"}
                            end,
                        },
                    },
                })
            end,
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
        -- { 'WhoIsSethDaniel/mason-tool-installer.nvim', }, -- REMOVED - not needed
        {
            'zbirenbaum/copilot.lua',
            cmd = 'Copilot',
            event = 'InsertEnter',
            config = function()
                require('copilot').setup({
                    panel = {
                        enabled = true,
                        auto_refresh = false,
                        keymap = {
                            jump_prev = "[[",
                            jump_next = "]]",
                            accept = "<CR>",
                            refresh = "gr",
                            open = "<M-CR>"
                        },
                        layout = {
                            position = "bottom",
                            ratio = 0.4
                        },
                    },
                    suggestion = {
                        enabled = true,
                        auto_trigger = true,
                        debounce = 75,
                        keymap = {
                            -- accept = "<M-l>",
                            accept = "<TAB>",
                            accept_word = false,
                            accept_line = false,
                            next = "<M-]>",
                            prev = "<M-[>",
                            dismiss = "<C-]>",
                        },
                    },
                    filetypes = {
                        yaml = true,
                        helm = true,
                        markdown = false,
                        help = false,
                        gitcommit = false,
                        gitrebase = false,
                        hgcommit = false,
                        svn = false,
                        cvs = false,
                        ["."] = false,
                    },
                    copilot_node_command = 'node',
                    server_opts_overrides = {},
                })
            end,
        },
        {
            'zbirenbaum/copilot-cmp',
            dependencies = { 'zbirenbaum/copilot.lua' },
            config = function()
                require('copilot_cmp').setup()
            end,
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
        { 'towolf/vim-helm' },
        -- DrumVim local plugin
        {
            'drumvim',
            dir = vim.fn.stdpath('config') .. '/drumvim',
            dependencies = { 'nvim-telescope/telescope.nvim' },
            lazy = false,
            config = function()
                require('drumvim').setup()
            end,
        },
    }

    local opts = {
        defaults = {
            lazy = true,
            version = false,           -- always use the latest git commit
        },
        checker = { enabled = false, }, -- DISABLED: was causing RPC URI errors with YAML files
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
        require 'mini.trailspace'.setup()
        require 'mini.tabline'.setup()
    end

    setup_mini_plugins()
    vim.g.claudecode_auto_setup = { auto_start = true }

end

return M
