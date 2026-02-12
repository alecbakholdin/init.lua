vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>rl", vim.cmd.restart)

require("config.lazy")
require("config.options")
require("config.keymap")
require("config.statusline")
