---@type vim.lsp.Config
return {
	cmd = { "typescript-language-server", "--stdio" },
	on_attach = function()
		--client.server_capabilities.documentFormattingProvider = false
		vim.keymap.set("n", "go", function()
			require('util').code_action_sync('source.organizeImports.ts')
		end, { buffer = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("TsLsUtils", {}),
			callback = function()
				require('util').code_action_sync('source.removeUnusedImports.ts')
			end
		})
	end,
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		hostInfo = "neovim",
	},

}
