-- LSP layer:
--   * mason.nvim + mason-lspconfig — install language-server binaries.
--   * nvim-lspconfig               — server defaults (cmd, root_dir, filetypes).
-- Configured via Neovim 0.11+ native vim.lsp.config / vim.lsp.enable.
-- LspAttach autocmd wires per-buffer keymaps and diagnostic config.
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "vtsls" },
                automatic_enable = false,
            })

            vim.diagnostic.config({
                severity_sort = true,
                virtual_text = { spacing = 4, prefix = "●" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "󰌶",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
            })

            -- vtsls tuning for the monorepo:
            --   * maxTsServerMemory: 8 GB cap (default ~3 GB OOMs on large workspaces).
            --   * autoImportFileExcludePatterns: skip generated/vendored trees when
            --     scanning the workspace for auto-import candidates on every keystroke.
            --   * enableServerSideFuzzyMatch: let the server filter completion items
            --     before sending — smaller payload, faster menu.
            vim.lsp.config("vtsls", {
                settings = {
                    typescript = {
                        tsserver = {
                            maxTsServerMemory = 8192,
                            -- Route hover/goto/completions through the (faster) syntax-only
                            -- server. The semantic server stays in charge of diagnostics.
                            useSyntaxServer = "always",
                            autoImportFileExcludePatterns = {
                                "**/node_modules/**",
                                "**/dist/**",
                                "**/build/**",
                                "**/.turbo/**",
                                "**/.next/**",
                                "**/.claude/**",
                            },
                        },
                    },
                    vtsls = {
                        experimental = {
                            completion = { enableServerSideFuzzyMatch = true },
                        },
                    },
                },
            })

            vim.lsp.enable("vtsls")

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
                    end

                    map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
                    map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
                    map("n", "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
                    map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")

                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
                    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
                    map("n", "<leader>co", function()
                        vim.lsp.buf.code_action({
                            apply = true,
                            context = { only = { "source.organizeImports" }, diagnostics = {} },
                        })
                    end, "Organize Imports")

                    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
                    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
                end,
            })
        end,
    },
}
