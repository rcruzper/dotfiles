return {
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
--                flavour = "frappe",
                integrations = {
                    neotree = true,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                },
            })

            vim.o.termguicolors = true
            vim.cmd.colorscheme "catppuccin-frappe"

            -- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
			for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
				vim.api.nvim_set_hl(0, group, {})
			end
        end,
    },
}

