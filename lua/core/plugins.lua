if not require('util').isV12() then
	vim.notify("Cannot install plugins on less than 0.12")
	return
end

vim.pack.add({ 'https://github.com/Mofiqul/dracula.nvim' })
vim.cmd.colorscheme('dracula')

vim.pack.add({ "https://github.com/tpope/vim-surround" })
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })
local fzf = require('fzf-lua')
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
vim.keymap.set("n", "<leader>fd", function()
	fzf.files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Find in current buffer's directory" })
-- muscle memory reasons
vim.keymap.set("n", "<leader>sg", fzf.live_grep)
-- lsp stuff
vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "Go to definition (fzf search)" })
vim.keymap.set("n", "gD", fzf.lsp_declarations, { desc = "Go to declaration (fzf search)" })
vim.keymap.set("n", "gt", fzf.lsp_typedefs, { desc = "Go to type defs (fzf search)" })
vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "Go to definition (fzf search)" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require('nvim-treesitter').setup()
