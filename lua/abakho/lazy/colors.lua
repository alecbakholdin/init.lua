function ColorMyPencils(color)
	vim.cmd.colorscheme(color or "tokyonight")
end

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {
            transparent = false,
        },
        config = function()
            ColorMyPencils()
        end,
    },
}

