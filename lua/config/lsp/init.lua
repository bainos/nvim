local M = {}

-- local util = require "lspconfig.util"

local servers = {
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "off",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	},
	sumneko_lua = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
					-- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
				},
				workspace = {
					checkThirdParty = false,
				},
				completion = { callSnippet = "Replace" },
				telemetry = { enable = false },
				hint = {
					enable = false,
				},
			},
		},
	},
	vimls = {},
	yamlls = {
		schemastore = {
			enable = true,
		},
		settings = {
			yaml = {
				hover = true,
				completion = true,
				validate = true,
				schemas = require("schemastore").json.schemas(),
			},
		},
	},
	bashls = {},
}

function M.on_attach(client, bufnr)
	local caps = client.server_capabilities

	-- Enable completion triggered by <C-X><C-O>
	-- See `:help omnifunc` and `:help ins-completion` for more information.
	if caps.completionProvider then
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	end

	-- Use LSP as the handler for formatexpr.
	-- See `:help formatexpr` for more information.
	if caps.documentFormattingProvider then
		vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
	end

	-- Configure highlighting
	require("config.lsp.highlighter").setup(client, bufnr)

	-- Configure formatting
	require("config.lsp.null-ls.formatters").setup(client, bufnr)

	-- tagfunc
	if caps.definitionProvider then
		vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities) -- for nvim-cmp

print(M.capabilities)

local opts = {
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	flags = {
		debounce_text_changes = 150,
	},
}

-- Setup LSP handlers
require("config.lsp.handlers").setup()

function M.setup()
	-- null-ls
	require("config.lsp.null-ls").setup(opts)

	-- Installer
	require("config.lsp.installer").setup(servers, opts)
end

local diagnostics_active = true

function M.toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

function M.remove_unused_imports()
	vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
	vim.cmd("packadd cfilter")
	vim.cmd("Cfilter /main/")
	vim.cmd("Cfilter /The import/")
	vim.cmd("cdo normal dd")
	vim.cmd("cclose")
	vim.cmd("wa")
end

return M
