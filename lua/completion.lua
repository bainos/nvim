local M = {}

function M.setup()
    -- completion/docs
    local cmp = require 'cmp'

    cmp.setup {
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                require 'luasnip'.lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
            ["<C-'>"] = cmp.mapping.scroll_docs(-4),
            ['<C-/>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm { select = false, }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp', },
            --{ name = "vsnip" }, -- For vsnip users.
            { name = 'luasnip', }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer', },
        }),
    }

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?', }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer', },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path', },
        }, {
            { name = 'cmdline', },
        }),
    })

    -- autopairs
    require 'nvim-autopairs'.setup {}
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    -- autocmd BufRead,BufNewFile ~/.pyblosxom/data/* set syntax=html
    local api = vim.api
    api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile', },
        --{ command = 'lua vim.lsp.buf.format()' }
        {
            pattern = { '*/templates/*.yaml', '*/templates/*.tpl', 'values.yaml', 'values*.yaml', },
            callback = function()
                api.nvim_buf_set_option(0, 'filetype', 'helm')
            end,
        }
    )
end

return M
