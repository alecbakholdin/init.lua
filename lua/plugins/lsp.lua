vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim", version = "v9.1.0" },
})

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"jsonls",
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.lsp.config("oxlint", {
	cmd = { "oxlint", "--lsp" },
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		-- Look for an active oxlint LSP client attached to this current file buffer
		local clients = vim.lsp.get_clients({ name = "oxlint", bufnr = 0 })
		if #clients > 0 then
			-- Synchronously request the language server to execute all available "fix all" fixes
			vim.lsp.buf.code_action({
				context = { only = { "source.fixAll.oxc" } },
				apply = true,
			})
		end
	end,
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		javascript = { "oxfmt", "prettierd", stop_after_first = true },
		typescript = { "oxfmt", "prettierd", stop_after_first = true },
		javascriptreact = { "oxfmt", "prettierd", stop_after_first = true },
		typescriptreact = { "oxfmt", "prettierd", stop_after_first = true },
		css = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
	},
	formatters = {
		-- Force overwrite or define oxfmt baseline properties explicitly
		oxfmt = {
			command = "oxfmt",
			args = { "--stdin-filepath", "$FILENAME" },
			stdin = true,
			condition = function(self, ctx)
				local found = vim.fs.find({
					".oxfmtrc.json",
					".oxfmtrc.jsonc",
					"oxfmt.config.ts",
				}, { path = ctx.filename, upward = true })
				return #found > 0 -- Returns true if a configuration file actually exists
			end,
		},
	},
})

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
