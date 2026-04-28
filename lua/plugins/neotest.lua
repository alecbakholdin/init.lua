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
