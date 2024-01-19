
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'} 
Plug 'preservim/nerdcommenter'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'd1373/my_gruvbox'
call plug#end()

""""""""""""
" Settings "
""""""""""""
" WSL yank support "
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
		augroup WSLYank
				autocmd!
				autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
		augroup END
endif
syntax enable
set background=dark
au ColorScheme * hi Normal ctermbg=none guibg=none
colorscheme gruvbox
"set termguicolors
set t_Co=256
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
set cursorline
set path+=**					" Searches current directory recursively.
set wildmenu					" Display all matches when tab complete.
set incsearch                   " Incremental search
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
"set number relativenumber       " Display line numbers
set number        " Display line numbers
set mouse=a
set clipboard+=unnamedplus
set go+=a               " Visual selection automatically copied to the clipboard
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:fzf_preview_command = 'bat --color=always --plain {-1}'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
let g:coc_global_extentions = [
	\ 'coc-snippet',
	\ 'coc-tabnine',
	\ 'coc-prettier',
	\ 'coc-html',
	\ 'coc-emmet',
	\ 'coc-jedi',
	\ 'coc-java',
	\ 'coc-css',
	\ 'coc-pyright',
	\ 'coc-git',
	\ 'coc-fzf-preview',
	\ 'coc-clangd',
	\ 'coc-flutter',
	\ 'coc-json',
	\ 'coc-tsserver',
	\]
let g:airline_theme = 'gruvbox'
" symbols section for unicode/airline symbols
let g:airline_powerline_fonts = 1

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
let NERDTreeShowHidden=1
"""""""""""""""""""
"    Remapings    "
"""""""""""""""""""
let mapleader = " "
map q <Nop>
map S <Nop>
nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>
map j gj
map k gk
nnoremap Q <nop>
""""""""""""""""""""""
" Leader Key Binding "
""""""""""""""""""""""
map <leader>N :tabnew<CR> 
nnoremap <leader>f <cmd>Files<cr>
nnoremap <leader>s <cmd>Ag<cr>
nnoremap <leader>b <cmd>Buffers<cr>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>m 	:Marks<CR>
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
map <leader>/ <Plug>NERDCommenterToggle
map <leader>a 0
map <leader>; $


"""""""""""""""""""""""
" Control Key Binding "
"""""""""""""""""""""""
map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
nnoremap <C-f> :BLines<CR>
inoremap <silent><expr> <c-space> coc#refresh()
xnoremap <C-j> <C-n>
xnoremap <C-k> <C-p>
nnoremap <C-j> <C-n>
nnoremap <C-k> <C-p>
vnoremap <C-j> <C-n>
vnoremap <C-k> <C-p>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap <C-b> :NERDTreeToggle<CR>
"""""""""""""""""""
" Alt Key Binding "
"""""""""""""""""""
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
map <A-H> :sp 
map <A-v> :vs
noremap <A-Left> :vertical resize +3<CR>
noremap <A-Right> :vertical resize -3<CR>
noremap <A-Up> :resize +3<CR>
noremap <A-Down> :resize -3<CR>



autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()
