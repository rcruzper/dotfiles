-- Catppuccin colorscheme + integrations for the plugins we actually use
-- (LSP, treesitter, gitsigns, snacks, lualine, mini, blink, which-key, trouble).
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            integrations = {
                blink_cmp = true,
                flash = true,
                gitsigns = true,
                mason = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                semantic_tokens = true,
                snacks = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.o.termguicolors = true
            vim.cmd.colorscheme("catppuccin-frappe")
        end,
    },
}
