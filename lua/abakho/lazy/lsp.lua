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
	    require("conform").setup({
		    formatters_by_ft = {
		    }
	    })

	    local cmp = require('cmp')
	    require('mason').setup()
	    require('mason-lspconfig').setup({
		ensure_installed = {
			"lua_ls"
		},
		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup {
					capabilities = capabilities
				}
			end,
		},
	    })

	    local cmp_select = { behavior = cmp.SelectBehavior.Select }
	    cmp.setup({
		    mapping = cmp.mapping.preset.insert({
			['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
			['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
			['<C-y>'] = cmp.mapping.confirm({ select= true }),
			['<C-Space>'] = cmp.mapping.complete(),
		    }),
		    sources = cmp.config.sources({
			    { name = 'nvim.lsp' },
			    { name = 'luasnip' },
		    }, {
			    { name = 'buffer' },
		    })
	    })

	    vim.diagnostic.config({
		    float = {
			    focusable = false,
			    style = "minimal",
			    border = "rounded",
			    source = "always",
			    header = "",
			    prefix = "",
		    },
	    })
    end
}
