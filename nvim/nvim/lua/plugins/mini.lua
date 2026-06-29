-- mini.* bundle:
--   * mini.pairs    — auto-pairs for (), [], {}, "", '', ``.
--   * mini.ai       — extended text objects (function, class, block, JSX tag, ...).
--   * mini.surround — add/delete/replace surroundings under the gs* prefix.
return {
    {
        "nvim-mini/mini.pairs",
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = true, terminal = false },
        },
    },

    {
        "nvim-mini/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                    d = { "%f[%d]%d+" },
                    u = ai.gen_spec.function_call(),
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
                },
            }
        end,
    },

    {
        "nvim-mini/mini.surround",
        keys = {
            { "gsa", desc = "Add Surrounding", mode = { "n", "x" } },
            { "gsd", desc = "Delete Surrounding" },
            { "gsf", desc = "Find Right Surrounding" },
            { "gsF", desc = "Find Left Surrounding" },
            { "gsh", desc = "Highlight Surrounding" },
            { "gsr", desc = "Replace Surrounding" },
            { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
        },
        opts = {
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",
            },
        },
    },
}
