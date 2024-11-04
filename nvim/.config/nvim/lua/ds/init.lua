require("ds.remap")
require("ds.packer")

vim.opt.clipboard:append { 'unnamedplus' }
vim.cmd([[
let g:clipboard = {
      \   'name': 'win32yank-wsl',
      \   'copy': {
      \      '+': 'win32yank.exe -i --crlf',
      \      '*': 'win32yank.exe -i --crlf',
      \    },
      \   'paste': {
      \      '+': 'win32yank.exe -o --lf',
      \      '*': 'win32yank.exe -o --lf',
      \   },
      \   'cache_enabled': 0,
      \ }


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

]])



vim.cmd([[

function! CloseBufferOrVim(force='')
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    exec ("quit" . a:force)


    quit
  else
    exec ("bdelete" . a:force)
  endif
endfunction


nnoremap <silent> <Leader>q :call CloseBufferOrVim()<CR>

nnoremap <silent> <Leader>Q :call CloseBufferOrVim('!')<CR>
nnoremap <silent> <Leader>s :w<CR>
]])
