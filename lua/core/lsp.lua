-- :h lsp-config

vim.o.completeopt = "fuzzy,menuone,noselect,popup,preview"
if require('util').isV12() then
	vim.o.autocomplete = true
	vim.o.complete = '.,o'
end
vim.diagnostic.config({ virtual_text = true })

-- enable configured language servers
-- you can find server configurations from lsp/*.lua files

vim.lsp.enable('gopls')
vim.lsp.enable('templ')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
--vim.lsp.enable('prettier')
vim.lsp.enable('svelte')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('eslint')

vim.api.nvim_create_user_command("LspLog", function()
	vim.ui.open(vim.lsp.log.get_filename(), { buffer = true })
end
, { desc = "Open LSP Log File" })

vim.lsp.config("*", {
	before_init = function(_, config)
		local bin = config and type(config.cmd) == 'table' and config.cmd[0]
		if bin then
			local which_out = vim.fn.system({ 'which', bin })
			if not which_out then
				vim.notify('missing some shit')
			end
		end
	end
})

-- more complicated tasks
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = function(ev)
		-- enable lsp completion
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)

		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		-- enable format on save
		if client and not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end

		-- show documentation preview on autocomplete hover
		if client and client:supports_method('completionItem/resolve') then
			vim.api.nvim_create_autocmd("CompleteChanged", {
				buffer = ev.buf,
				callback = function()
					local item = vim.v.event.completed_item
					local lsp_data = item and
						item.user_data and
						item.user_data.nvim and
						item.user_data.nvim.lsp and
						item.user_data.nvim.lsp.completion_item
					if not lsp_data then return end

					client.request(client, 'completionItem/resolve', lsp_data, function(_, result)
						local doc_lines = result and result.documentation and
							vim.lsp.util.convert_input_to_markdown_lines(result.documentation)
						local doc_details = result and result.detail and
							vim.split(result.detail, '\n', { trimempty = true })

						local result_data = doc_lines or doc_details
						if result_data and #result_data > 0 then
							local pum_pos = vim.fn.pum_getpos()
							local screen_w = vim.o.columns

							local pum_left = pum_pos.col or 0
							local pum_right = (pum_pos.col or 0) + (pum_pos.width or 0) + (pum_pos.scrollbar and 1 or 0)

							local room_left = pum_left or 0
							local room_right = screen_w - pum_right
							local win_left = (room_right > room_left) and pum_right or 0
							local win_width = math.max(room_right, room_left)


							local _, win = vim.lsp.util.open_floating_preview(result_data, "markdown", {
								focus_id = "autocomplete-signature-help",
								close_events = { "CursorMoved", "BufLeave", "InsertLeave", "TextChangedI" },
								max_width = win_width
							})
							vim.api.nvim_win_set_config(win, {
								relative = 'editor',
								row = pum_pos.row or 0,
								col = win_left,
								width = win_width
							})
						end
					end)
				end,
			})
		end
	end,
})
