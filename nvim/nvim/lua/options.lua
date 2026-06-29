-- Enable relative line numbers
vim.opt.nu = true
vim.opt.rnu = true
-- vim.opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]

-- Set tabs to 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Enable auto indenting and set it to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- Enable incremental searching
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true

-- Disable text wrap
vim.opt.wrap = false

-- Set leader key to space
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

vim.opt.mouse = ""

-- Sign column siempre visible (evita el "salto" cuando aparecen diagnostics)
vim.opt.signcolumn = "yes"

-- Statusline única global (laststatus=3 — coincide con lualine.globalstatus)
vim.opt.laststatus = 3

-- Undo persistente entre sesiones
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Reduce updatetime (afecta CursorHold → document_highlight más reactivo)
vim.opt.updatetime = 200

-- Reduce timeoutlen (which-key popup más rápido)
vim.opt.timeoutlen = 300

-- Confirma antes de cerrar sin guardar en vez de error
vim.opt.confirm = true

-- Preview en vivo de :substitute
vim.opt.inccommand = "nosplit"

-- Splits abren abajo/derecha
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Usa ripgrep para :grep
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.opt.guicursor = 'a:hor20'
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"toml", "yaml"},
  command = "setlocal indentkeys-=0#",
})

-- 2-space indent for web/JS family and config formats
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "typescript", "typescriptreact", "javascript", "javascriptreact",
    "json", "jsonc",
    "yaml",
    "html", "css", "scss", "sass", "less",
    "markdown",
  },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

