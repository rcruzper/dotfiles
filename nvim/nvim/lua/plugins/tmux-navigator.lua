-- christoomey/vim-tmux-navigator — seamless <C-hjkl> movement between neovim
-- splits and tmux panes. Pairs with the matching plugin in tmux.conf: when the
-- edge of nvim is reached, focus crosses into the adjacent tmux pane (and back).
return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>",      desc = "Go to Left Window / Tmux Pane" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>",      desc = "Go to Lower Window / Tmux Pane" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>",        desc = "Go to Upper Window / Tmux Pane" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>",     desc = "Go to Right Window / Tmux Pane" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Go to Previous Window / Tmux Pane" },
    },
}
