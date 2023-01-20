local M = {}

function M.setup(servers, server_options)
	local lspconfig = require("lspconfig")

	require("mason").setup({
		log_level = vim.log.levels.DEBUG,
	})
	require("mason-null-ls").setup({
		automatic_setup = true,
	})
	require("mason-null-ls").setup_handlers()

	require("mason-tool-installer").setup({
		ensure_installed = {
			"stylua",
			"shfmt",
			"shellcheck",
		},
		auto_update = false,
		run_on_start = true,
	})

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers),
		automatic_installation = false,
	})

	-- Package installation folder
	local install_root_dir = vim.fn.stdpath("data") .. "/mason"

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
			lspconfig[server_name].setup(opts)
		end,
		["sumneko_lua"] = function()
			local opts = vim.tbl_deep_extend("force", server_options, servers["sumneko_lua"] or {})
			require("neodev").setup({})
			lspconfig.sumneko_lua.setup(opts)
		end,
	})
end

return M
