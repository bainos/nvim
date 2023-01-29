local M = {}

function M.setup()
  -- language servers manager
  require("mason").setup()
  require("mason-null-ls").setup({
    ensure_installed = {
      ---- lua
      --"luacheck",
      --"stylua",
      ---- python
      --"black",
      --"flake8",
      -- bash
      "shellcheck", -- this will work with bashls even if not loaded in null-ls
      "shfmt",
      ---- yaml/json
      --"yamlfmt",
      ----"jq", -- masom fails for arm64 arch
      --"fixjson",
      ---- markdown
      --"markdownlint",
    },
    automatic_installation = false,
    --automatic_setup = true, -- Recommended, but optional
  })

  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      --      -- common
      --      {
      --        null_ls.builtins.code_actions.refactoring,
      --        filetypes = { "lua", "python" }
      --      },
      --      -- lua
      --null_ls.builtins.completion.luasnip,
      --null_ls.builtins.diagnostics.luacheck,
      --null_ls.builtins.formatting.stylua,
      --null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.formatting.shfmt,
      --null_ls.builtins.formatting.black,
    },
  })

  --require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  })

  -- autopairs
  require("nvim-autopairs").setup({})
end

return M
