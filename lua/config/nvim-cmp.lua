local M = {}

function M.setup()
    -- completion/docs
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'

    cmp.setup {
        completion = {
            autocomplete = false,
        },
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                require 'luasnip'.lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        window = {
            --completion = cmp.config.window.bordered(),
            --documentation = cmp.config.window.bordered(),
        },
        mapping = {
            ['<C-n>'] = cmp.mapping {
                i = cmp.mapping.complete(),
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- they way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's', }),

            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's', }),

            ['<C-f>'] = cmp.mapping.scroll_docs(-4),
            ['<C-b>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm { select = false, }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources {
            { name = 'nvim_lsp', },
            { name = 'luasnip', },
            { name = 'buffer', },
            { name = 'path', },
        },
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
end

return M
