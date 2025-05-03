vim.opt.clipboard:append("unnamedplus")
--vim.g.clipboard = {
--name = 'win32yank-wsl',
--copy = {
--['+'] = 'win32yank.exe -i --crlf',
--['*'] = 'win32yank.exe -i --crlf',
--},
--paste = {
--['+'] = 'win32yank.exe -o --lf',
--['*'] = 'win32yank.exe -o --lf',
--},
--cache_enabled = 0,
--}
---- Editor settings
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.path:append("**") -- Recursive path search
vim.opt.wildmenu = true
vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.g.have_nerd_font = false
vim.opt.showmode = false
vim.opt.undofile = true
