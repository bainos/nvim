local M = {}

function M.setup()
    local plugins = {
        { 'ellisonleao/gruvbox.nvim', priority = 1000 },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                require 'telescope'.setup {
                    defaults = {
                        mappings = {
                            n = {
                                ['<C-d>'] = require 'telescope.actions'.delete_buffer
                            }
                        },
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
                }
            end,
        },
        {
            'yetone/avante.nvim',
            event = 'VeryLazy',
            lazy = false,
            version = false,
            build = 'make BUILD_FROM_SOURCE=true',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'MunifTanjim/nui.nvim',
                'MeanderingProgrammer/render-markdown.nvim',
                'nvim-tree/nvim-web-devicons',
            },
            config = function()
                require('avante').setup({
                    provider = 'bedrock',
                    auto_suggestions = true,
                    providers = {
                        bedrock = {
                            aws_profile = 'mxm-engineers-interns',
                            model = 'us.anthropic.claude-haiku-4-5-20251001-v1:0',
                            aws_region = 'us-east-1',
                        },
                    },
                    behaviour = {
                        auto_suggestions = true,
                        auto_set_highlight_group = true,
                        support_paste_from_clipboard = true,
                    },
                    mappings = {
                        ask = '<leader>ca',
                        edit = '<leader>ce',
                        refresh = '<leader>cr',
                        suggestion = {
                            accept = '<Tab>',
                            next = '<M-]>',
                            prev = '<M-[>',
                            dismiss = '<C-]>',
                        },
                    },
                    hints = { enabled = true },
                    windows = {
                        position = 'right',
                        wrap = true,
                        width = 30,
                    },
                })
            end,
            keys = {
                {
                    '<Tab>',
                    function()
                        if require('avante.suggestion').is_visible() then
                            return require('avante.suggestion').accept()
                        else
                            return '<Tab>'
                        end
                    end,
                    mode = 'i',
                    expr = true,
                    desc = 'Accept Avante suggestion',
                },
                {
                    '<leader>cc',
                    function()
                        require('avante.api').ask()
                    end,
                    mode = { 'n', 'v' },
                    desc = 'Avante: Ask AI',
                },
                {
                    '<leader>ce',
                    function()
                        require('avante.api').edit()
                    end,
                    mode = { 'n', 'v' },
                    desc = 'Avante: Edit selection',
                },
                {
                    '<leader>cr',
                    function()
                        require('avante.api').refresh()
                    end,
                    mode = 'n',
                    desc = 'Avante: Refresh',
                },
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
                        'c',
                        'lua',
                        'vim',
                        'vimdoc',
                        'query',
                        'markdown',
                        'markdown_inline',
                    },
                    sync_install = false,
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                    matchup = {
                        enable = true,
                    },
                }
            end,
        },
        { 'williamboman/mason.nvim', },
        {
            'echasnovski/mini.nvim',
            version = false,
            config = function()
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
                    options = {
                        permanent_delete = true,
                    },
                }
                require 'mini.statusline'.setup()
                require 'mini.tabline'.setup()
                require 'mini.trailspace'.setup()
            end,
        },
        { 'nvim-tree/nvim-web-devicons', lazy = true },
        {
            'folke/which-key.nvim',
            event = 'VeryLazy',
            opts = {},
        },
        { 'mg979/vim-visual-multi', branch = 'master' },
        'nvim-lua/plenary.nvim',
        'folke/snacks.nvim',
    }

    local opts = {
        performance = {
            disabled_plugins = {
                'gzip',
                'matchit',
                'netrwPlugin',
                'rplugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    }

    require 'lazy'.setup(plugins, opts)
end

return { setup = M.setup }
