return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {},
	keys = {
		{
			"<leader>sl",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore last session",
		},
	},
}
