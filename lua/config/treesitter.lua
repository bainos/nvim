local M = {}

function M.setup()
	require("nvim-treesitter.configs").setup({
		-- One of "all", "maintained" (parsers with maintainers), or a list of languages
		ensure_installed = {
			"python",
			"lua",
			"hcl",
			"bash",
			"comment",
			"awk",
			"vim",
		},

		-- Install languages synchronously (only applied to `ensure_installed`)
		sync_install = false,

		highlight = {
			-- `false` will disable the whole extension
			enable = true,
		},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},

		indent = { enable = true, disable = { "python", "java", "rust", "lua" } },

		-- vim-matchup
		matchup = {
			enable = true,
		},
	})
	-- require("treesitter-context").setup {
	--   enable = true,
	-- }
end

return M
