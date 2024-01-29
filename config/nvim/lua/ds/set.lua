-- vim commands port

vim.cmd[[
set t_Co=256
set cursorline
set path+=**					" Searches current directory recursively.
set wildmenu					" Display all matches when tab complete.
set incsearch                   " Incremental search
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set number        " Display line numbers
set mouse=a
set clipboard+=unnamedplus
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

""let g:airline_theme = 'minimalist'
let g:rainbow_active = 1
]]
if vim.fn.argc(-1) == 0 then
  vim.cmd("NvimTreeOpen")
end
vim.opt.fillchars:append { eob = " " }

