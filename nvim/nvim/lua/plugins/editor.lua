-- Editor enhancements bundle:
--   * flash.nvim       — label-based motion (s/S) and remote/treesitter-aware jumps.
--   * todo-comments    — highlight TODO/FIX/HACK/NOTE/... and pickers/jumps over them.
--   * ts-comments      — treesitter-aware commenting so JSX/TSX comments use {/* */}.
return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,             desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,       desc = "Flash Treesitter" },
            { "r", mode = "o",               function() require("flash").remote() end,          desc = "Remote Flash" },
            { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },       function() require("flash").toggle() end,          desc = "Toggle Flash Search" },
            {
                "<c-space>", mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter({
                        actions = {
                            ["<c-space>"] = "next",
                            ["<BS>"] = "prev",
                        },
                    })
                end,
                desc = "Treesitter Incremental Selection",
            },
        },
    },

    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {},
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
            { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
            { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
        },
    },

    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
