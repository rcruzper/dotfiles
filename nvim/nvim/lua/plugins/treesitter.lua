-- nvim-treesitter (main branch) + nvim-treesitter-textobjects:
-- syntax-aware highlight, folding, indentation (disabled for JS/TS — see issue 7840),
-- and AST-based text objects / movement (]f/[f functions, ]c/[c classes, ]a/[a args).
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        build = function()
            require("nvim-treesitter").update()
        end,
        opts_extend = { "ensure_installed" },
        opts = {
            highlight = { enable = true },
            indent = {
                enable = true,
                -- Indenter de nvim-treesitter en branch `main` sobre-indenta TS/TSX/JS/JSX:
                -- añade +1 nivel tras statements ya completas (ej. tras `const x = 1;`).
                -- Hasta que se migre el módulo de indent, dejamos que el ftplugin built-in
                -- (GetJavascriptIndent) gestione la indentación en estos filetypes.
                -- Upstream: https://github.com/nvim-treesitter/nvim-treesitter/issues/7840
                disable = {
                    "typescript", "typescriptreact", "tsx",
                    "javascript", "javascriptreact", "jsx",
                },
            },
            folds = { enable = true },
            ensure_installed = {
                "bash", "c", "diff", "html", "javascript", "jsdoc", "json",
                "lua", "luadoc", "luap", "markdown", "markdown_inline", "printf",
                "python", "query", "regex", "toml", "tsx", "typescript",
                "vim", "vimdoc", "xml", "yaml",
            },
        },
        config = function(_, opts)
            require("nvim-treesitter").install(opts.ensure_installed)

            if opts.folds.enable then
                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.opt.foldenable = false
            end

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    if not lang then return end
                    if opts.highlight.enable then
                        pcall(vim.treesitter.start, ev.buf)
                    end
                    if opts.indent.enable and not vim.tbl_contains(opts.indent.disable or {}, ev.match) then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                move = { set_jumps = true },
            })

            local moves = {
                goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
                goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
            }

            for method, keymaps in pairs(moves) do
                for key, query in pairs(keymaps) do
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        require("nvim-treesitter-textobjects.move")[method](query)
                    end, { desc = method .. " " .. query, silent = true })
                end
            end
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
