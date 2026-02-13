vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = { "*" },
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.cmd(":startinsert")
		end
	end,
})

local tracked_terminal = nil
local function get_open_term()
	if tracked_terminal then
		if vim.api.nvim_buf_is_loaded(tracked_terminal) then
			return tracked_terminal
		else
			tracked_terminal = nil
		end
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
			tracked_terminal = buf
			return tracked_terminal
		end
	end
	return nil
end
local function toggleterm()
	local term_buf = get_open_term()
	local term_win = term_buf and vim.fn.bufwinid(term_buf)

	if term_buf == nil or term_buf <= 0 then
		vim.cmd("below terminal")
	elseif term_win == nil or term_win <= 0 then
		vim.cmd("below sbuffer " .. term_buf)
	elseif term_win == vim.api.nvim_get_current_win() then
		vim.api.nvim_win_close(term_win, true)
	else
		vim.api.nvim_set_current_win(term_win)
		vim.schedule(vim.cmd.startinsert)
	end
end
vim.keymap.set("n", "<leader>lg", ":terminal lazygit<CR>")
vim.keymap.set("t", "<C-w>", "<cmd><C-\\><C-n><C-w><CR>", { noremap = true })
vim.keymap.set("t", "<Esc>", [[ <C-\><C-n> ]], { noremap = true })
vim.keymap.set({ "n", "i", "t" }, "<C-`>", toggleterm, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "i", "t" }, "<C-_>", toggleterm, { desc = "Toggle Terminal" })

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
