local M = {}

function M.setup()

    require('config.aws-credentials').setup()
    local bedrock_keys = require('config.aws-credentials').get_bedrock_keys()
    if bedrock_keys then
        vim.env.BEDROCK_KEYS = bedrock_keys
    end

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
                            -- aws_profile = 'default',
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
