vim.pack.add({
	-- installed elsewhere "https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest",

	-- adapters
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/marilari88/neotest-vitest",
})

local neotest = require("neotest")
neotest.setup({
	adapters = {
		require("neotest-jest")({
			jestCommand = "npm test --",
			jestArguments = function(defaultArguments, context)
				return defaultArguments
			end,
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
			isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
		}),
		require("neotest-vitest"),
	},
})

-- return a parameterless function that invokes the passed function with vim.fn.expand('%') when called
local function current_file(fn)
	return function()
		fn(vim.fn.expand("%"))
	end
end

vim.keymap.set("n", "<Leader>tt", neotest.run.run, { desc = "Run Nearest Test" })
vim.keymap.set("n", "<Leader>tf", current_file(neotest.run.run), { desc = "Run Test File" })
vim.keymap.set("n", "<Leader>ts", neotest.summary.toggle, { desc = "Toggle Summary" })
vim.keymap.set("n", "<Leader>to", neotest.output_panel.toggle, { desc = "Toggle Output Panel" })
vim.keymap.set("n", "<Leader>tw", current_file(neotest.watch.toggle), { desc = "Toggle watch for current file" })
