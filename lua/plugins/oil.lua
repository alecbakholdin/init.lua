vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim", version = "v2.16.0" },
	{ src = "https://github.com/nvim-mini/mini.icons", version = "stable" },
})
require("oil").setup()
vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<CR>")
