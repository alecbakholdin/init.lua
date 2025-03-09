require("abakho.remap")
require("abakho.lazy_init")
require("abakho.set")

local augroup = vim.api.nvim_create_augroup
local AbakhoGroup = augroup("Abakho", {})
local autocmd = vim.api.nvim_create_autocmd

--autocmd("BufWritePre", {
--pattern = "*.go",
--callback = function()
--local params = vim.lsp.util.make_range_params()
--params.context = { only = { "source.organizeImports" } }
---- buf_request_sync defaults to a 1000ms timeout. Depending on your
---- machine and codebase, you may want longer. Add an additional
---- argument after params if you find that you have to write the file
---- twice for changes to be saved.
---- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
--local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
--for cid, res in pairs(result or {}) do
--for _, r in pairs(res.result or {}) do
--if r.edit then
--local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
--vim.lsp.util.apply_workspace_edit(r.edit, enc)
--end
--end
--end
--vim.lsp.buf.format({ async = false })
--end,
--})

autocmd("LspAttach", {
	group = AbakhoGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		-- I know how to use these
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
		vim.keymap.set({ "i", "n" }, "<C-.>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float, opts)

		-- I don't know what these do yet. We'll get there one day
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	end,
})
