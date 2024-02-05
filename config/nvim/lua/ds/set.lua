-- vim commands port

vim.cmd [[
set t_Co=256
set cursorline
set path+=**					" Searches current directory recursively.
set wildmenu					" Display all matches when tab complete.
set incsearch                   " Incremental search
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set number        " Display line numbers
set tabstop=2     "tab width
set shiftwidth=2  "indent size
set expandtab     "use space to instead the tab character
set smarttab
set mouse=a
set clipboard+=unnamedplus
]]
if vim.fn.argc(-1) == 0 then
  vim.cmd("NvimTreeOpen")
end
vim.opt.fillchars:append { eob = " " }
