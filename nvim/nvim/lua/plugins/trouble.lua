-- trouble.nvim: persistent side panel for diagnostics, LSP references/definitions,
-- document/workspace symbols, quickfix and loclist. Complements snacks pickers —
-- pickers are one-shot fuzzy lookups, Trouble is a panel you keep open while you work.
return {
    {
        "folke/trouble.nvim",
        enabled = false,
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                 desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",   desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",        desc = "Symbols (Trouble)" },
            { "<leader>cS", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references/definitions/... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                    desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                     desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    },
}
