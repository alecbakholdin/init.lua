return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
	},
	config = function()
		-- get neotest namespace (api call creates or returns namespace)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)
		local neotest = require("neotest")
		neotest.setup({
			-- your neotest config here
			adapters = {
				require("neotest-go"),
			},
		})
		vim.keymap.set("n", "<leader>tt", function()
			neotest.run.run()
		end, { desc = "Test current test" })
		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Test current file" })
		vim.keymap.set("n", "<leader>tw", function()
			neotest.output.open({ enter = true })
		end, { desc = "Test window open" })
	end,
}
