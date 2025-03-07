return {
	"kawre/leetcode.nvim",
	config = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		-- "ibhagwan/fzf-lua",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		lang = "golang",
	},
}
