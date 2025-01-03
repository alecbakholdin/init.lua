return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
	    local cmp = require('cmp')
	    require('mason')
	    require('mason-lspconfig').setup({
		ensure_installed = {
			"lua_ls",
			"gopls"
		},
		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup {
					capabilities = capabilities
				}
			end,
		}
	    })
    end
}
