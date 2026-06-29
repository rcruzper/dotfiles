-- blink.cmp: completion engine with a Rust-backed fuzzy matcher.
-- Sources: LSP, filesystem paths, open-buffer words.
return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "VeryLazy",
        opts = {
            keymap = { preset = "enter" },
            appearance = { nerd_font_variant = "mono" },
            completion = {
                accept = { auto_brackets = { enabled = true } },
            },
            sources = {
                default = { "lsp", "path", "buffer" },
            },
        },
    },
}
