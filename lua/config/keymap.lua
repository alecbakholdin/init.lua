vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")

local term_buf = nil
local function toggleterm()
	if term_buf and not vim.api.nvim_buf_is_loaded(term_buf) then
		term_buf = nil
	end
	local term_win = term_buf and vim.fn.bufwinid(term_buf)

	if term_buf == nil or term_buf <= 0 then
		term_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_command("sbuf " .. term_buf)
		vim.fn.jobstart(os.getenv("SHELL") or "sh", { term = true })
		vim.schedule(vim.cmd.startinsert)
	elseif term_win == nil or term_win <= 0 then
		vim.cmd("below sbuffer " .. term_buf)
		vim.schedule(vim.cmd.startinsert)
	elseif term_win == vim.api.nvim_get_current_win() then
		vim.api.nvim_win_close(term_win, true)
	else
		vim.api.nvim_set_current_win(term_win)
		vim.schedule(vim.cmd.startinsert)
	end
end
vim.keymap.set("n", "<leader>lg", ":terminal lazygit<CR>")
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { noremap = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set({ "n", "i", "t" }, "<C-`>", toggleterm, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "i", "t" }, "<C-_>", toggleterm, { desc = "Toggle Terminal (c-/)" })

vim.keymap.set("i", "<C-H>", "<C-W>", { desc = "Delete word" })
vim.keymap.set("i", "<C-BS>", "<C-W>", { desc = "Delete word" })
vim.keymap.set("n", "<C-H>", "db", { desc = "Delete word" })
vim.keymap.set("n", "<C-BS>", "db", { desc = "Delete word" })

-- diagnostic motions
local function jump_severity(count, sev)
	return function()
		vim.diagnostic.jump({
			count = count,
			severity = sev,
		})
	end
end

vim.keymap.set(
	"n",
	"[e",
	jump_severity(-1, { min = vim.diagnostic.severity.WARN }),
	{ desc = "Previous Warning/Error" }
)
vim.keymap.set("n", "]e", jump_severity(1, { min = vim.diagnostic.severity.WARN }), { desc = "Previous Warning/Error" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action)
vim.keymap.set("i", "<C-.>", vim.lsp.buf.code_action)

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "grn", vim.lsp.buf.rename)
