vim.g.mapleader = " "
vim.o.background = "dark"
vim.o.backup = false

vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.number = true
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.swapfile = false

vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 50
--vim.o.winborder = "rounded"
vim.o.wrap = false

vim.g.db_ui_use_nerd_fonts = 1
--vim.g.db_ui_auto_execute_table_helpers = 0
--vim.g.db_ui_use_live_queries = 0
vim.g.db_ui_execute_on_save = 0

-- utillity functions
local function run_command_in_dir(command, directory)
	local current_dir = vim.fn.getcwd() -- Store current directory
	vim.cmd("cd " .. directory) -- Change to target directory
	local output = vim.fn.system(command) -- Execute command
	vim.cmd("cd " .. current_dir) -- Revert to original directory
	return output
end
local function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end
local function vim_cmd(cmd)
	return function()
		vim.cmd(cmd)
	end
end
local function get_plugin(name)
	for _, v in pairs(vim.pack.get()) do
		if v.spec.name == name then
			return v
		end
	end
	return nil
end

--keymaps
vim.keymap.set("n", "<leader>oc", ":edit ~/.config/nvim/init.lua\n", { desc = "[o]pen [c]onfig", silent = true })
vim.keymap.set("n", "<leader>rl", ":restart\n", { desc = "reload/restart" })

vim.keymap.set({ "n", "i" }, "<C-BS>", vim_cmd("normal db"), { desc = "delete a word backspace normal" })
vim.keymap.set({ "n", "i" }, "<C-j>", "<C-w>j", { desc = "Move down window" })
vim.keymap.set({ "n", "i" }, "<C-l>", "<C-w>l", { desc = "Move right window" })
vim.keymap.set({ "n", "i" }, "<C-k>", "<C-w>k", { desc = "Move up window" })
vim.keymap.set({ "n", "i" }, "<C-h>", "<C-w>h", { desc = "Move left window" })
vim.keymap.set("n", "<leader>lg", vim.cmd.LazyGit)

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight" },
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/olrtg/nvim-emmet" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },

	--telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", name = "telescope-fzf-native" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-frecency.nvim" },

	-- lsp and formatting
	{ src = "https://github.com/mason-org/mason.nvim.git", version = "v2.0.1" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim", version = "v2.1.0" },
	{ src = "https://github.com/jay-babu/mason-null-ls.nvim", version = "v2.6.0" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
	{ src = "https://github.com/nvimtools/none-ls.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip", name = "luasnip" },
	{ src = "https://github.com/nvim-svelte/nvim-svelte-snippets" },
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-svelte/nvim-svelte-check" },

	-- ui niceties
	{ src = "https://github.com/folke/which-key.nvim", version = "v3.17.0" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/yavorski/lualine-macro-recording.nvim" },
})
require("notify").setup({ max_width = 60, merge_duplicates = true })
require("noice").setup()
vim.notify = require("noice").notify
require("lualine").setup({
	sections = {
		lualine_c = { "macro_recording", "%S" },
	},
})

vim.cmd.colorscheme("tokyonight")

-- treesitter
require("nvim-treesitter.configs").setup({
	modules = {},
	ensure_installed = { "javascript", "typescript", "go", "lua", "vim", "vimdoc" },
	sync_install = false,
	auto_install = true,
	ignore_install = {},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- search (telescope)
require("telescope").setup({
	defaults = { path_display = { "filename_first", "truncate" } },
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})
local fzfPath = get_plugin("telescope-fzf-native")
if fzfPath ~= nil then
	run_command_in_dir("make", fzfPath.path)
end
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("frecency")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "[f]ind [f]iles" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[s]earch [g]rep" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "[f]ind [b]uffers" })
vim.keymap.set("n", "<leader>fo", telescope.oldfiles, { desc = "[f]ind [o]ld files" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "[f]ind [h]elp" })
vim.keymap.set("n", "<leader>tr", telescope.resume)

-- lsp and formatting
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"ts_ls",
		"eslint",
		"svelte",
		"jsonls",
		"tailwindcss",
		"emmet_language_server",
		"denols",
	},
	automatic_installation = true,
	automatic_enable = true,
})
local util = require("lspconfig.util")
local get_deno_root = util.root_pattern("deno.json", "deno.jsonc")
local get_ts_root = util.root_pattern("package.json", "tsconfig.json")
vim.lsp.config("denols", {
	root_dir = function(buf, on_dir)
		local fname = vim.api.nvim_buf_get_name(buf)
		local ts_root = get_ts_root(fname)
		local deno_root = get_deno_root(fname)
		if deno_root and not ts_root then
			on_dir(deno_root)
		elseif deno_root and ts_root and string.len(deno_root) > string.len(ts_root) then
			on_dir(deno_root)
		end
	end,
	single_file_support = false,
})
vim.lsp.config("ts_ls", {
	root_dir = function(buf, on_dir)
		local fname = vim.api.nvim_buf_get_name(buf)
		local ts_root = get_ts_root(fname)
		local deno_root = get_deno_root(fname)

		vim.notify("testing")
		if ts_root and not deno_root then
			on_dir(ts_root)
		elseif deno_root and ts_root and string.len(ts_root) > string.len(deno_root) then
			on_dir(ts_root)
		end
	end,
	single_file_support = false,
})

require("mason-null-ls").setup({
	ensure_installed = { "jq", "djlint", "prettierd", "emmet" },
	automatic_installation = true,
})
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		html = { "djlint" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		svelte = { "prettierd" },
	},
})

local lsp_keybinds_group = vim.api.nvim_create_augroup("UserLspKeybinds", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_keybinds_group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client.name == "emmet_language_server" then
			vim.keymap.set("v", "St", require("nvim-emmet").wrap_with_abbreviation, { buffer = args.buf })
		end
	end,
})

vim.keymap.set("n", "gr", telescope.lsp_references)
vim.keymap.set("n", "gs", telescope.lsp_dynamic_workspace_symbols, { desc = "[f]ind [s]ymbols" })
vim.keymap.set("n", "gd", telescope.lsp_definitions)
vim.keymap.set("n", "gt", telescope.lsp_type_definitions)

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>co", function()
	vim.lsp.buf.code_action({
		context = {
			only = { "source.organizeImports" },
			diagnostics = {},
		},
		apply = true,
	})
end, { desc = "Organize Imports" })

vim.keymap.set("n", "<C-Space>", vim.lsp.buf.document_symbol, { desc = "show documentation" })

local function next_severity(severity)
	return function()
		vim.diagnostic.jump({ severity = severity, count = 1 })
	end
end
local function prev_severity(severity)
	return function()
		vim.diagnostic.jump({ severity = severity, count = -1 })
	end
end

vim.keymap.set("n", "]e", next_severity(vim.diagnostic.severity.ERROR), { desc = "Jump to next error" })
vim.keymap.set("n", "[e", prev_severity(vim.diagnostic.severity.ERROR), { desc = "Jump to prev error" })
vim.keymap.set("n", "]w", next_severity(vim.diagnostic.severity.WARN), { desc = "Jump to next warning" })
vim.keymap.set("n", "[w", prev_severity(vim.diagnostic.severity.WARN), { desc = "Jump to prev warning" })
vim.keymap.set("n", "]i", next_severity(vim.diagnostic.severity.INFO), { desc = "Jump to next info" })
vim.keymap.set("n", "[i", prev_severity(vim.diagnostic.severity.INFO), { desc = "Jump to prev info" })
vim.diagnostic.config({ virtual_text = true })

-- autocomplete
require("svelte-check").setup()
require("lazydev").setup()
require("luasnip").setup()
require("nvim-svelte-snippets").setup({
	enable = true,
	auto_detect = true,
	prefix = "kit",
})
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<Tab>"] = {
			function(cmp)
				if not cmp.is_menu_visible() then
					return false
				end
				cmp.select_and_accept({
					callback = function()
						-- delete the rest of the word if present (alphanumeric characters)
						local col = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[2]
						local line = vim.api.nvim_get_current_line()
						local selectedChar = string.sub(line, col + 1, col + 1)
						if col < string.len(line) and string.find(selectedChar, "%w") ~= nil then
							vim.cmd("normal de", { silent = true })
							-- edge case if last word on the line
							if col == string.len(vim.api.nvim_get_current_line()) then
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<Right>", true, true, true),
									"i",
									true
								)
							end
						end
					end,
				})
				return true
			end,
			"fallback",
		},
		["<Enter>"] = { "select_and_accept", "fallback" },
		["<C-BS>"] = { "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		menu = { auto_show = true },
		documentation = { auto_show = true },
		trigger = { show_in_snippet = false },
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "dadbod", "buffer" },
		per_filetype = {
			sql = { "snippets", "dadbod", "buffer" },
		},
		providers = {
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
		},
	},
})
require("which-key").add({ { "<leader>S", group = "SQL" } })
vim.keymap.set("n", "<leader>su", vim.cmd.DBUI, { desc = "SQL UI" })
vim.keymap.set("n", "<leader>sb", vim.cmd.DBUIFindBuffer, { desc = "Attach Buffer" })

-- sql

-- nvim-tree
require("nvim-tree").setup({
	git = {
		ignore = false,
	},
	update_focused_file = {
		enable = true,
	},
	filters = {
		dotfiles = true,
	},
})

vim.keymap.set("n", "<Leader>e", function()
	if string.find(vim.api.nvim_buf_get_name(0), "NvimTree") then
		vim.cmd("NvimTreeToggle")
	else
		vim.cmd("NvimTreeFocus")
	end
end)

-- toggleterm
require("toggleterm").setup()
vim.keymap.set({ "n", "i", "t" }, "<C-/>", vim.cmd.ToggleTerm, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "i", "t" }, "<C-_>", vim.cmd.ToggleTerm, { desc = "Toggle Terminal" })
function _G.set_terminal_keymaps()
	if string.find(vim.api.nvim_buf_get_name(0), "toggleterm") == nil then
		return
	end
	--vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-/><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	--vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
