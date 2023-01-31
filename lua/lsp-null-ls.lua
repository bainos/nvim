local M = {}

function M.setup()
    -- language servers manager
    require 'mason'.setup()
    require 'mason-null-ls'.setup {
        ensure_installed = {
            'prettier_d_slim', -- npm install -g prettier_d_slim
            --"shellcheck", -- this will work with bashls even if not loaded in null-ls
            'shfmt',
        },
        automatic_installation = false,
        --automatic_setup = true, -- Recommended, but optional
    }

    local null_ls = require 'null-ls'
    null_ls.setup {
        sources = {
            --      -- common
            --      {
            --        null_ls.builtins.code_actions.refactoring,
            --        filetypes = { "lua", "python" }
            --      },
            --      -- lua
            --null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.formatting.prettier_d_slim.with { filetypes = { 'yaml', 'helm', }, },
        },
    }

    --require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.
end

return M
