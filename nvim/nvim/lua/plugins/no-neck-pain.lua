-- shortcuts/no-neck-pain.nvim — centers the active buffer by opening two empty
-- splits on each side. Manual only (`,uc`); it does not enable on VimEnter. If the
-- resulting side margin is smaller than minSideBufferWidth, no margins are created;
-- on VimResized the margins are recomputed or closed.
-- Verified with vim-tmux-navigator: <c-h>/<c-l> from the main window still reach the
-- tmux panes, because the plugin re-routes focus synchronously on WinEnter and the
-- navigator sees no window change (upstream issue #438 does not apply here).
--
-- Separators: a window draws the separator on its right. The left margin's one is
-- blanked through the margin's own `fillchars` (plugin option `buffers.wo`). The
-- main window's one (main | right margin) is painted in the background color
-- through a per-window highlight namespace, which, unlike a window option, is not
-- inherited by new splits. It is applied only while both margins exist, so real
-- splits keep their separators. Themes without a Normal background are left alone.
local ns = vim.api.nvim_create_namespace("no-neck-pain-separator")
local painted = {}
local wrap_before -- `wrap` of the main window before centering, restored on disable

local function sync_separator()
    local sides, others = 0, {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "no-neck-pain" then
                sides = sides + 1
            else
                table.insert(others, win)
            end
        end
    end
    local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    local main = (bg and sides == 2 and #others == 1) and others[1] or nil

    for win in pairs(painted) do
        if win ~= main then
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_hl_ns(win, -1)
            end
            painted[win] = nil
        end
    end
    if main then
        vim.api.nvim_set_hl(ns, "WinSeparator", { fg = bg })
        if not painted[main] then
            vim.api.nvim_win_set_hl_ns(main, ns)
            painted[main] = true
        end
    end
end

return {
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        cmd = "NoNeckPain",
        keys = {
            { "<leader>uc", function() require("no-neck-pain").toggle() end, desc = "Toggle Centered Buffer" },
        },
        opts = {
            width = 120,
            minSideBufferWidth = 10, -- default; minimum margin per side to create the splits
            buffers = {
                wo = { fillchars = "eob: ,vert: " }, -- hide `~` and the left margin's separator
            },
            -- The plugin opens and closes the margins with noautocmd/eventignore, so
            -- WinNew/WinClosed never fire for them: hook enable/disable here instead.
            -- Centering also wraps long lines in the main window (`,uw` still toggles it).
            callbacks = {
                postEnable = function()
                    sync_separator()
                    wrap_before = vim.wo.wrap
                    vim.wo.wrap = true
                end,
                postDisable = function()
                    sync_separator()
                    if wrap_before ~= nil then
                        vim.wo.wrap = wrap_before
                    end
                end,
            },
        },
        config = function(_, opts)
            require("no-neck-pain").setup(opts)
            -- User splits, closes, resizes and theme changes make the plugin re-layout
            -- the margins silently, behind a 2 ms debounce: re-sync once it has settled.
            vim.api.nvim_create_autocmd({ "WinNew", "WinClosed", "WinResized", "VimResized", "ColorScheme" }, {
                group = vim.api.nvim_create_augroup("no-neck-pain-separator", { clear = true }),
                desc = "Hide the separator between the centered buffer and the right margin",
                callback = function()
                    vim.defer_fn(sync_separator, 50)
                end,
            })
        end,
    },
}
