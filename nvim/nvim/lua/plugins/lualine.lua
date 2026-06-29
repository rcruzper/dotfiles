-- lualine.nvim: statusline (single global one — laststatus=3).
-- Shows mode, git branch+diff, diagnostics, filename, filetype, progress.
return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            -- PERF: evitar el sistema de require interno de lualine
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            return {
                options = {
                    theme = "auto",
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = " ",
                                warn  = " ",
                                info  = " ",
                                hint  = "󰌶 ",
                            },
                        },
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { "filename", path = 1 },
                    },
                    lualine_x = {
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                        },
                        {
                            "diff",
                            symbols = {
                                added    = " ",
                                modified = " ",
                                removed  = " ",
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added    = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed  = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function() return " " .. os.date("%R") end,
                    },
                },
                extensions = { "lazy" },
            }
        end,
    },
}
