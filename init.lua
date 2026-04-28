vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>rl", vim.cmd.restart)

require("config.options")
require("config.keymap")
require("config.statusline")

-- add plugins
vim.pack.add({
	"https://github.com/tpope/vim-surround",
})

-- require all files in the ./lua/plugins directory
local config_path = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.readdir(config_path, [[v:val =~ '\.lua$']])
for _, file in ipairs(files) do
	local module_name = file:gsub("%.lua$", "")
	require("plugins." .. module_name)
end
