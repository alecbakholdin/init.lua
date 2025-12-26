local start_time = os.clock()
if vim.fn.has("nvim-0.11") == 0 then
	vim.notify("NativeVim only supports Neovim 0.11+", vim.log.levels.ERROR)
	return
end


require("core.options")
vim.keymap.set("n", "<leader>rl", "<cmd>mksession! .session.nvim | restart source .session.nvim<CR>")
require("core.treesitter")
require("core.statusline")
require("core.plugins")
require("core.keymap")
require("core.lsp")

print(string.format("Started in %dms", 1000 * (os.clock() - start_time)))
