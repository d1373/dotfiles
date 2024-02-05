require("ds.map")
require("ds.pckr")
require("ds.plugset")
require("ds.set")  

-- NETRW basic Set
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
-- WSL Yank Support
vim.cmd([[
 let g:clipboard = {
\             'name': 'win32yank-wsl',
\            'copy': {
\              '+': 'win32yank.exe -i --crlf',
\               '*': 'win32yank.exe -i --crlf',
\             },
\            'paste': {
\               '+': 'win32yank.exe -o --lf',
\               '*': 'win32yank.exe -o --lf',
\            },
\            'cache_enabled': 0,
\          }
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
