--@type vim.lsp.Config
return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	root_markers = {
		'tailwind.config.js',
		'tailwind.config.cjs',
		'tailwind.config.mjs',
		'tailwind.config.ts',
		'postcss.config.js',
		'package.json'
	},
	filetypes = {
		"html", "css", "scss", "javascript", "javascriptreact",
		"typescript", "typescriptreact", "svelte", "vue"
	},
	on_attach = function(client, bufnr)
		-- Optional: Debugging to confirm it attached
		client.server_capabilities.documentFormattingProvider = false
	end,
}
