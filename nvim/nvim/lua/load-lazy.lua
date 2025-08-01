local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 10000 }
}
local ots = {}

require("lazy").setup({
    { import = "plugins" },
}, {
    change_detection = {
        enabled = true,
        notify = false,
    },
})

require("notify").setup({})

vim.notify = require("notify")

require("hardtime").setup({
  disabled_keys = {
    ["<Up>"] = false, -- Allow <Up> key
    ["<Down>"] = false, -- Allow <Up> key
    ["<Right>"] = false, -- Allow <Up> key
    ["<Left>"] = false, -- Allow <Up> key
  },
})

