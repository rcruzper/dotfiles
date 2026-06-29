-- Formatting layer:
--   * conform.nvim           — formatter dispatcher with format-on-save.
--                              prettier for web filetypes, stylua for Lua, shfmt for shell.
--   * mason-tool-installer   — keeps the external formatter binaries installed via Mason.
return {
    {
        "stevearc/conform.nvim",
        enabled = false,
        event = "BufWritePre",
        keys = {
            {
                "<leader>cf",
                function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
                mode = { "n", "v" },
                desc = "Format",
            },
        },
        opts = {
            formatters_by_ft = {
                typescript      = { "prettier" },
                typescriptreact = { "prettier" },
                javascript      = { "prettier" },
                javascriptreact = { "prettier" },
                json            = { "prettier" },
                jsonc           = { "prettier" },
                yaml            = { "prettier" },
                markdown        = { "prettier" },
                css             = { "prettier" },
                html            = { "prettier" },
                lua             = { "stylua" },
                sh              = { "shfmt" },
                bash            = { "shfmt" },
            },
            format_on_save = {
                timeout_ms = 3000,
                lsp_format = "fallback",
            },
        },
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        enabled = false,
        dependencies = { "mason-org/mason.nvim" },
        event = "VeryLazy",
        opts = {
            ensure_installed = { "prettier", "eslint_d", "stylua", "shfmt" },
            run_on_start = true,
        },
    },
}
