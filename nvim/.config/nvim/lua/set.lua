local vo = vim.opt
local vg = vim.g
vo.clipboard:append("unnamedplus")
vo.termguicolors = true
vo.cursorline = true
vo.path:append("**") -- Recursive path search
vo.wildmenu = true
vo.incsearch = true
vo.hidden = true
vo.backup = false
vo.swapfile = false
vo.tabstop = 4
vo.shiftwidth = 4
vo.expandtab = true
vo.smarttab = true
vo.mouse = "a"
vo.number = true
vo.relativenumber= true
vg.have_nerd_font = false
vo.showmode = false
vo.undofile = true
vo.laststatus = 3
vo.winborder = "rounded"
