-- nvim-lint: asynchronous linting that complements LSP diagnostics.
-- eslint_d on JS/TS. eslint_d does not search config upward, so we locate the
-- nearest ESLint config and set the linter's cwd accordingly — required for
-- per-package rules in a monorepo (flat or legacy config).
return {
    {
        "mfussenegger/nvim-lint",
        enabled = false,
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                typescript      = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                javascript      = { "eslint_d" },
                javascriptreact = { "eslint_d" },
            }

            local flat_configs = {
                "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
            }
            local all_configs = vim.list_extend(vim.list_extend({}, flat_configs), {
                ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc",
            })

            local function run_lint()
                local names = lint._resolve_linter_by_ft(vim.bo.filetype)
                if #names == 0 then return end
                if vim.tbl_contains(names, "eslint_d") then
                    local file = vim.api.nvim_buf_get_name(0)
                    if file ~= "" then
                        local cfg = vim.fs.find(all_configs, { path = file, upward = true })[1]
                        if cfg then
                            local is_flat = vim.tbl_contains(flat_configs, vim.fs.basename(cfg))
                            lint.linters.eslint_d.cwd = vim.fs.dirname(cfg)
                            lint.linters.eslint_d.env = is_flat and { ESLINT_USE_FLAT_CONFIG = "true" } or nil
                        end
                    end
                end
                lint.try_lint(names)
            end

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                callback = run_lint,
            })
        end,
    },
}
