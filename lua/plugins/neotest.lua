return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		"nvim-neotest/neotest-jest",
		{
			"fredrikaverpil/neotest-golang",
			version = "*",
			build = function()
				vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait()
			end,
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestArguments = function(defaultArguments, _)
						return defaultArguments
					end,
					jestConfigFile = "custom.jest.config.ts",
					env = { CI = true },
					cwd = function(_)
						return vim.fn.getcwd()
					end,
					isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
				}),
				require("neotest-golang")({ runner = "gotestsum" }),
			},
		})
	end,
	keys = {
		{
			mode = "n",
			"<leader>tt",
			function()
				require("neotest").run.run()
			end,
			desc = "Run the nearest test",
		},
		{
			mode = "n",
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle test summary",
		},
		{
			mode = "n",
			"<leader>tw",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Open test output window",
		},
		{
			mode = "n",
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run all tests in the current file",
		},
		{
			mode = "n",
			"<leader>td",
			function()
				require("neotest").run.run(vim.fn.expand("%:h"))
			end,
			desc = "Run all tests in the current directory",
		},
		{
			mode = "n",
			"<leader>ta",
			function()
				require("neotest").run.run(vim.fn.getcwd())
			end,
			desc = "Run all tests in project",
		},
	},
}
