--@type vim.lsp.Config
return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
		'vue',
		'svelte',
		'astro',
		'htmlangular',
	},
	root_markers = {
		'.eslintrc',
		'.eslintrc.js',
		'.eslintrc.cjs',
		'.eslintrc.yaml',
		'.eslintrc.yml',
		'.eslintrc.json',
		'eslint.config.js',
		'eslint.config.mjs',
		'eslint.config.cjs',
		'eslint.config.ts',
		'eslint.config.mts',
		'eslint.config.cts',
	},
	before_init = function()
		require('util').ensure_binary_installed('vscode-eslint-language-server',
			{ 'npm', 'i', '-g', 'vscode-langservers-extracted' })
	end,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
			vim.notify('executing' .. vim.uri_from_bufnr(bufnr))
			client:request_sync('workspace/executeCommand', {
				command = 'eslint.applyAllFixes',
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = vim.lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, {})
	end,
	settings = {
		validate = 'on',
		---@diagnostic disable-next-line: assign-type-mismatch
		packageManager = nil,
		useESLintClass = false,
		experimental = {
			useFlatConfig = false,
		},
		codeActionOnSave = {
			enable = false,
			mode = 'all',
		},
		format = false,
		quiet = false,
		onIgnoredFiles = 'off',
		rulesCustomizations = {},
		run = 'onType',
		problems = {
			shortenToSingleLine = false,
		},
		-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
		-- This path is relative to the workspace folder (root dir) of the server instance.
		nodePath = '',
		-- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
		workingDirectory = { mode = 'auto' },
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = 'separateLine',
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
}
