-- folke/snacks.nvim: collection of small UI/UX modules used as foundation.
-- Enabled: picker (telescope replacement, used everywhere for fuzzy search and
-- LSP nav), input/notifier (replace vim.ui.input and vim.notify), statuscolumn,
-- terminal toggle, scope highlights, words (symbol references), zen/zoom modes.
local function find_root(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(buf)
    path = path ~= "" and vim.fs.dirname(path) or vim.uv.cwd()
    local git = vim.fs.find(".git", { path = path, upward = true })[1]
    if git then return vim.fs.dirname(git) end
    local marker = vim.fs.find(
        { "package.json", "pyproject.toml", "Cargo.toml", "go.mod" },
        { path = path, upward = true }
    )[1]
    return marker and vim.fs.dirname(marker) or vim.uv.cwd()
end

local function pick(source, opts)
    return function()
        opts = vim.tbl_extend("force", {}, opts or {})
        if opts.root ~= false then
            opts.cwd = find_root()
        end
        opts.root = nil
        Snacks.picker.pick(source, opts)
    end
end

-- En terminal mode: <c-h/j/k/l> salta a la ventana correspondiente.
-- Si el terminal es flotante, deja pasar la tecla nativamente.
local function term_nav(dir)
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
            vim.cmd.wincmd(dir)
        end)
    end
end

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            picker = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
            statuscolumn = { enabled = true },
            indent = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            words = { enabled = true },
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            bufdelete = { enabled = true },
            zen = { enabled = true },
            terminal = {
                win = {
                    keys = {
                        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window",  expr = true, mode = "t" },
                        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
                        hide_slash      = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
                        hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
                    },
                },
            },
        },
        keys = {
            { "<leader>n",       function() Snacks.picker.notifications() end,                            desc = "Notification History" },
            { "<leader>un",      function() Snacks.notifier.hide() end,                                   desc = "Dismiss All Notifications" },

            { "<c-/>",           function() Snacks.terminal(nil, { cwd = find_root() }) end,             desc = "Terminal (Root Dir)", mode = { "n", "t" } },
            { "<c-_>",           function() Snacks.terminal(nil, { cwd = find_root() }) end,             desc = "which_key_ignore",    mode = { "n", "t" } },

            { "<leader>bb",      "<cmd>e #<cr>",                                                          desc = "Switch to Other Buffer" },
            { "<leader>bd",      function() Snacks.bufdelete() end,                                       desc = "Delete Buffer" },
            { "<leader>bo",      function() Snacks.bufdelete.other() end,                                 desc = "Delete Other Buffers" },
            { "<leader>bi",      function() Snacks.bufdelete.invisible() end,                             desc = "Delete Invisible Buffers" },
            { "<leader>bD",      "<cmd>:bd<cr>",                                                          desc = "Delete Buffer and Window" },

            { "<leader>uz",      function() Snacks.zen() end,                                             desc = "Toggle Zen Mode" },
            { "<leader>uZ",      function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },

            { "<leader>,",       function() Snacks.picker.buffers() end,                                  desc = "Buffers" },
            { "<leader>/",       pick("grep"),                                                            desc = "Grep (Root Dir)" },
            { "<leader>:",       function() Snacks.picker.command_history() end,                          desc = "Command History" },
            { "<leader><space>", pick("files"),                                                           desc = "Find Files (Root Dir)" },

            { "<leader>ff",      pick("files"),                                                           desc = "Find Files (Root Dir)" },
            { "<leader>fF",      pick("files", { root = false }),                                         desc = "Find Files (cwd)" },
            { "<leader>fb",      function() Snacks.picker.buffers() end,                                  desc = "Buffers" },
            { "<leader>fB",      function() Snacks.picker.buffers({ hidden = true, nofile = true }) end,  desc = "Buffers (all)" },
            { "<leader>fg",      function() Snacks.picker.git_files() end,                                desc = "Find Files (git-files)" },
            { "<leader>fr",      pick("recent"),                                                          desc = "Recent" },
            { "<leader>fR",      function() Snacks.picker.recent({ filter = { cwd = true } }) end,       desc = "Recent (cwd)" },

            { "<leader>sb",      function() Snacks.picker.lines() end,                                    desc = "Buffer Lines" },
            { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                             desc = "Grep Open Buffers" },
            { "<leader>sg",      pick("grep"),                                                            desc = "Grep (Root Dir)" },
            { "<leader>sG",      pick("grep", { root = false }),                                          desc = "Grep (cwd)" },
            { "<leader>sw",      pick("grep_word"),                                                       desc = "Word (Root Dir)", mode = { "n", "x" } },
            { "<leader>sW",      pick("grep_word", { root = false }),                                     desc = "Word (cwd)", mode = { "n", "x" } },
            { '<leader>s"',      function() Snacks.picker.registers() end,                                desc = "Registers" },
            { "<leader>s/",      function() Snacks.picker.search_history() end,                           desc = "Search History" },
            { "<leader>sa",      function() Snacks.picker.autocmds() end,                                 desc = "Autocmds" },
            { "<leader>sc",      function() Snacks.picker.command_history() end,                          desc = "Command History" },
            { "<leader>sC",      function() Snacks.picker.commands() end,                                 desc = "Commands" },
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,                              desc = "Diagnostics" },
            { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                       desc = "Buffer Diagnostics" },
            { "<leader>sh",      function() Snacks.picker.help() end,                                     desc = "Help Pages" },
            { "<leader>sH",      function() Snacks.picker.highlights() end,                               desc = "Highlights" },
            { "<leader>si",      function() Snacks.picker.icons() end,                                    desc = "Icons" },
            { "<leader>sj",      function() Snacks.picker.jumps() end,                                    desc = "Jumps" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                                  desc = "Keymaps" },
            { "<leader>sl",      function() Snacks.picker.loclist() end,                                  desc = "Location List" },
            { "<leader>sm",      function() Snacks.picker.marks() end,                                    desc = "Marks" },
            { "<leader>sM",      function() Snacks.picker.man() end,                                      desc = "Man Pages" },
            { "<leader>sR",      function() Snacks.picker.resume() end,                                   desc = "Resume" },
            { "<leader>sq",      function() Snacks.picker.qflist() end,                                   desc = "Quickfix List" },
            { "<leader>su",      function() Snacks.picker.undo() end,                                     desc = "Undotree" },
            { "<leader>sp",      function() Snacks.picker.lazy() end,                                     desc = "Search for Plugin Spec" },

            { "<leader>gs",      function() Snacks.picker.git_status() end,                               desc = "Git Status" },
            { "<leader>gS",      function() Snacks.picker.git_stash() end,                                desc = "Git Stash" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,                                  desc = "Git Log" },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                                 desc = "Git Diff (hunks)" },

            { "<leader>uC",      function() Snacks.picker.colorschemes() end,                             desc = "Colorschemes" },
        },
    },
}
