--@type vim.lsp.Config
return {
	cmd = { "svelteserver", "--stdio" },
	root_markers = { "svelte.config.js", "svelte.config.ts", "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	filetypes = { "svelte" },

	on_attach = function(client, _)
		--client.server_capabilities.documentFormattingProvider = false
		vim.keymap.set("n", "go", function()
			require('util').code_action_sync('source.organizeImports.ts')
		end, { buffer = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.svelte",
			group = vim.api.nvim_create_augroup("MySvelteGroup", {}),
			callback = function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						---@diagnostic disable-next-line: assign-type-mismatch
						only = { 'source.removeUnusedImports' },
						diagnostics = {}
					}
				})
			end
		})
		vim.api.nvim_create_autocmd('BufWritePost', {
			pattern = { '*.js', '*.ts' },
			group = vim.api.nvim_create_augroup('MySvelteGroup', {}),
			callback = function(ctx)
				-- internal API to sync changes that have not yet been saved to the file system
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
			end,
		})
	end,
}
