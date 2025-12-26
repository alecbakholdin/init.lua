vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	pattern = { "*" },
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.cmd(":startinsert")
		end
	end
})
vim.keymap.set("n", "<leader>lg", "<cmd>terminal lazygit<CR>")

vim.keymap.set("i", "<C-H>", "<C-W>", { desc = "Delete word" })
vim.keymap.set("i", "<C-BS>", "<C-W>", { desc = "Delete word" })
vim.keymap.set("n", "<C-H>", "db", { desc = "Delete word" })
vim.keymap.set("n", "<C-BS>", "db", { desc = "Delete word" })

vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { desc = "Open Omnifunc (autocomplete)" })

-- diagnostic motions
function jump_severity(count, sev)
	return function()
		vim.diagnostic.jump({
			count = count,
			severity = sev
		})
	end
end

vim.keymap.set("n", "[e", jump_severity(-1, { min = vim.diagnostic.severity.WARN }), { desc = "Previous Warning/Error" })
vim.keymap.set("n", "]e", jump_severity(1, { min = vim.diagnostic.severity.WARN }), { desc = "Previous Warning/Error" })
