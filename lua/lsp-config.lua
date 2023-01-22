local M = {}

function M.setup()
    local lsp_servers = {
      "bashls",
        "dockerls",
      "pyright",
      --"sumneko_lua",
      --"terraformls",
      "yamlls",
    }

  -- highlitimg
  require 'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    ensure_installed = {
      "bash",
      "dockerfile",
      "python",
      "lua",
      "terraform",
      "vim",
      "yaml",
    },
  }

  -- language servers manager
  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = lsp_servers,
    automatic_installation = false,
  })

  -- language server providers configuration
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  --
  -- npm i -g bash-language-server
  require 'lspconfig'.bashls.setup {}

  -- npm install -g dockerfile-language-server-nodejs
  require 'lspconfig'.dockerls.setup {}

  -- https://github.com/microsoft/pyright
  require 'lspconfig'.pyright.setup {}

  -- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line
  require 'lspconfig'.sumneko_lua.setup {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'use' }
        }
      }
    }
  }

  -- https://github.com/hashicorp/terraform-ls/releases
  require 'lspconfig'.terraformls.setup {}

  -- yarn global add yaml-language-server
  require 'lspconfig'.yamlls.setup {}

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false
  }
  )

  -- completion/docs
  local cmp = require 'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  for _, server in pairs(lsp_servers) do
    require('lspconfig')[server].setup {
      capabilities = capabilities
    }
  end

  -- autopairs
  require 'nvim-autopairs'.setup {}
  -- If you want insert `(` after select function or method item
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

return M
