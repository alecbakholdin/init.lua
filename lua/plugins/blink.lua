return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets", "nvim-tree/nvim-web-devicons" },

	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		completion = {
			documentation = { auto_show = true },
			trigger = {
				show_on_trigger_character = true, -- Trigger on '.' and other LSP-defined chars
				show_on_keyword = true,
			},
		},
		fuzzy = { implementation = "lua" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
}
