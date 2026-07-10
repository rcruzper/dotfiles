-- Rose Pine colorscheme. Loaded eagerly with high priority so it applies
-- before the UI plugins draw (same pattern as snacks.lua). termguicolors is
-- already enabled globally in lua/options.lua. Rose Pine auto-supports the
-- plugins we use (LSP, treesitter, gitsigns, snacks, mini, blink, which-key).
return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("rose-pine")
    end,
}
