local M = {}

function M.setup()
	-- Indicate first time installation
	-- local is_boostrap = false

	-- packer.nvim configuration
	local conf = {
		profile = {
			enable = true,
			threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			fn.system({
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			})
			-- is_boostrap = true
			vim.cmd([[packadd packer.nvim]])
		end

		-- Run PackerCompile if there are changes in this file
		-- vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
		local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
		vim.api.nvim_create_autocmd(
			{ "BufWritePost" },
			{ pattern = vim.fn.expand("$MYVIMRC"), command = "source <afile> | PackerCompile", group = packer_grp }
		)
	end

	-- Plugins
	local function plugins(use)
		use({ "wbthomason/packer.nvim" })

		-- Performance
		use({ "lewis6991/impatient.nvim" })

		-- Load only when require
		use({ "nvim-lua/plenary.nvim", module = "plenary" })

		-- Autopairs
		use({
			"windwp/nvim-autopairs",
			opt = false,
			event = "InsertEnter",
			module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
			config = function()
				require("config.autopairs").setup()
			end,
		})

		-- Completion
		use({
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			opt = false,
			config = function()
				require("config.cmp").setup()
			end,
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"ray-x/cmp-treesitter",
				"hrsh7th/cmp-cmdline",
				"saadparwaiz1/cmp_luasnip",
				{
					"onsails/lspkind-nvim",
					module = { "lspkind" },
				},
			},
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			opt = false,
			event = "BufReadPre",
			wants = {
				"nvim-lsp-installer",
				"cmp-nvim-lsp",
				"lua-dev.nvim",
				"vim-illuminate",
				"null-ls.nvim",
			},
			config = function()
				require("config.lsp").setup()
			end,
			requires = {
				"williamboman/nvim-lsp-installer",
				{
					"hrsh7th/cmp-nvim-lsp",
					config = function()
						require("cmp").setup({
							sources = {
								{ name = "nvim_lsp" },
							},
						})
					end,
				},
				"folke/lua-dev.nvim",
				"RRethy/vim-illuminate",
				"jose-elias-alvarez/null-ls.nvim",
				{
					"j-hui/fidget.nvim",
					config = function()
						require("fidget").setup({})
					end,
				},
				{
					"b0o/schemastore.nvim",
					module = { "schemastore" },
				},
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "jayp0521/mason-null-ls.nvim" },
			},
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("config.treesitter").setup()
			end,
			requires = {
				{ "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPre" },
			},
		})

		-- Better Comment
		use({
			"numToStr/Comment.nvim",
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("config.comment").setup()
			end,
			disable = false,
		})
		use({ "tpope/vim-commentary", keys = { "gc", "gcc", "gbc" }, disable = true })

		-- Better surround
		use({ "tpope/vim-surround", event = "BufReadPre" })
		use({
			"Matt-A-Bennett/vim-surround-funk",
			event = "BufReadPre",
			config = function()
				require("config.surroundfunk").setup()
			end,
			disable = true,
		})
	end

	-- Init and start packer
	packer_init()
	local packer = require("packer")

	-- Performance
	pcall(require, "impatient")
	-- pcall(require, "packer_compiled")

	packer.init(conf)
	packer.startup(plugins)
end

return M
