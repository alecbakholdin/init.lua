-- @type vim.lsp.Config
return {
	cmd = function(dispatchers)
		local closing = false
		local srv = {}

		function srv.request(method, params, callback)
			if method == 'initialize' then
				vim.schedule(
					function()
						local result = vim.system({ 'which', 'prettierd' }):wait()
						if result.code > 0 then
							vim.notify('prettierd not installed', vim.log.levels.WARN)
						else
							callback(nil, {
								capabilities = {
									documentFormattingProvider = true
								}
							})
						end
					end
				)
			elseif method == 'textDocument/formatting' then
				vim.schedule(function()
					local buf = vim.uri_to_bufnr(params.textDocument.uri)
					local filename = vim.uri_to_fname(params.textDocument.uri)
					local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
					local buf_text = vim.iter(buf_lines):join('\n')
					if buf_text == "" or buf_text == "\n" then
						callback(nil, {})
						return
					end

					local out_text = vim.fn.system({ 'prettierd', '--stdin-filepath', filename }, buf_lines)
					if vim.v.shell_error ~= 0 then
						vim.notify("Prettier failed:\n" .. out_text:gsub("\27%[[0-9;]*m", ""), vim.log.levels.ERROR)
						callback(nil, nil)
						return
					end
					local out_lines = vim.split(out_text, '\n')
					local vim_diff = vim.text.diff(buf_text, out_text, { result_type = "indices" })

					local diffs = {}
					if vim_diff then
						---@diagnostic disable-next-line: param-type-mismatch
						for _, hunk in ipairs(vim_diff) do
							local a_start = hunk[1]
							local a_end = a_start + hunk[2]
							local b_start = hunk[3]
							local b_end = b_start + hunk[4]
							local textedit = {
								range = {
									start = { line = a_start - 1, character = 0 },
									['end'] = { line = a_end - 1, character = #(buf_lines[a_start] or '') }
								},
								newText = vim.iter(vim.list_slice(out_lines, b_start, b_end)):join('\n') .. '\n'
							}
							table.insert(diffs, textedit)
						end
					end

					callback(nil, diffs)
				end)
			elseif method == "shutdown" then
				callback(nil, nil)
			end

			return true, 1
		end

		function srv.notify(method, _)
			if method == 'exit' then
				closing = true
			end
		end

		function srv.is_closing() return closing end

		function srv.terminate() closing = true end

		return srv
	end,

	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git", ".prettierrc" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
}
