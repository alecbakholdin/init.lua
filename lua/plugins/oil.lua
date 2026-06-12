vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons", version = "stable" },
	{ src = "https://github.com/stevearc/oil.nvim", version = "v2.16.0" },
})
require("mini.icons").setup()
require("oil").setup({
	columns = {
		"icon",
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
