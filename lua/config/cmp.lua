local M = {}

vim.o.completeopt = "menu,menuone,noselect"

local compare = require("cmp.config.compare")
local lspkind = require("lspkind")

local source_mapping = {
	nvim_lsp = "[Lsp]",
	buffer = "[Buffer]",
	nvim_lua = "[Lua]",
	treesitter = "[Tree]",
	path = "[Path]",
}

-- local kind_icons = {
--   Text = "",
--   Method = "",
--   Function = "",
--   Constructor = "",
--   Field = "",
--   Variable = "",
--   Class = "ﴯ",
--   Interface = "",
--   Module = "",
--   Property = "ﰠ",
--   Unit = "",
--   Value = "",
--   Enum = "",
--   Keyword = "",
--   Snippet = "",
--   Color = "",
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = "",
--   Constant = "",
--   Struct = "",
--   Event = "",
--   Operator = "",
--   TypeParameter = "",
-- }

function M.setup()
	local cmp = require("cmp")

	cmp.setup({
		completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
		-- experimental = { native_menu = false, ghost_text = false },
		-- view = {
		--   entries = "native",
		-- },
		sorting = {
			priority_weight = 2,
			comparators = {
				-- require "cmp_tabnine.compare",
				compare.score,
				compare.recently_used,
				compare.offset,
				compare.exact,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
			},
		},
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Up>"] = cmp.mapping.select_prev_item(),
			["<Down>"] = cmp.mapping.select_next_item(),
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 40,

				before = function(entry, vim_item)
					vim_item.kind = lspkind.presets.default[vim_item.kind]

					local menu = source_mapping[entry.source.name]
					vim_item.menu = menu
					return vim_item
				end,
			}),
		},
		sources = {
			{ name = "nvim_lsp", max_item_count = 15 },
			{ name = "nvim_lsp_signature_help", max_item_count = 5 },
			{ name = "treesitter", max_item_count = 5 },
			{ name = "rg", max_item_count = 2 },
			{ name = "buffer", max_item_count = 5 },
			{ name = "nvim_lua" },
			{ name = "path" },
			{ name = "crates" },
		},
		window = {
			documentation = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
			},
		},
	})

	-- Use buffer source for `/`
	cmp.setup.cmdline("/", {
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':'
	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})

	-- Auto pairs
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
end

return M
