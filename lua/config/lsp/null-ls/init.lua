local M = {}

local nls = require("null-ls")
local nls_utils = require("null-ls.utils")
local b = nls.builtins
local with_diagnostics_code = function(builtin)
	return builtin.with({
		diagnostics_format = "#{m} [#{c}]",
	})
end

local sources = {
	-- formatting
	b.formatting.prettierd,
	b.formatting.shfmt,
	b.formatting.shellharden,
	b.formatting.fixjson,
	b.formatting.black.with({ extra_args = { "--fast" } }),
	b.formatting.isort,
	b.formatting.stylua,

	-- diagnostics
	b.diagnostics.write_good,
	b.diagnostics.markdownlint,
	b.diagnostics.ruff.with({
		extra_args = { "--max-line-length=180" },
	}),
	with_diagnostics_code(b.diagnostics.shellcheck),

	-- code actions
	b.code_actions.refactoring,
	b.code_actions.shellcheck,

	-- hover
	b.hover.dictionary,
}

function M.setup(opts)
	nls.setup({
		debug = false,
		debounce = 150,
		save_after_format = false,
		sources = sources,
		on_attach = opts.on_attach,
		root_dir = nls_utils.root_pattern(".git"),
	})
end

return M
