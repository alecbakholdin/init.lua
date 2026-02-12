return {
	"ibhagwan/fzf-lua",
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({ winopts = { preview = { layout = "vertical" } } })
		fzf.register_ui_select()
		vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Search with grep" })
		vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "Find keymap" })
		vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Find help tags" })
		vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Resume previous find" })
		vim.keymap.set("n", "<leader>fm", fzf.marks, { desc = "Find marks" })
		vim.keymap.set("n", "<leader>fj", fzf.jumps, { desc = "Find jumps" })
		vim.keymap.set("n", "<leader>fy", fzf.registers, { desc = "Find in registers (y for yank)" })
		vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Find in old files (recent files)" })
		vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Find document symbols" })
		vim.keymap.set("n", "<leader>fS", fzf.lsp_workspace_symbols, { desc = "Find workspace symbols" })
		vim.keymap.set("n", "<leader>fp", fzf.git_files, { desc = "Find project (Git) files" })
		vim.keymap.set("n", "<leader>fd", function()
			fzf.files({ cwd = vim.fn.expand("%:p:h") })
		end, { desc = "Find in current buffer's directory" })
	end,
}
