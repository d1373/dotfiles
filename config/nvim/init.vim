let mapleader = " "
map q <Nop>
map <leader>N :tabnew<CR> 
map <C-l> :tabn<CR>
map <C-h> :tabp<CR> 
call plug#begin('~/.vim/plugged')
Plug 'ap/vim-css-color'                            " Color previews for CSS
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'xianzhon/vim-code-runner'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'mattn/emmet-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' 
Plug 'turbio/bracey.vim' 
Plug 'neoclide/coc.nvim', {'branch': 'release'} 
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdcommenter'
Plug 'cometsong/CommentFrame.vim'
Plug 'dikiaap/minimalist'
Plug 'sheerun/vim-polyglot'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'uiiaoo/java-syntax.vim'
Plug 'tpope/vim-fugitive'
Plug 'dhruvasagar/vim-table-mode'
Plug 'akinsho/toggleterm.nvim'
Plug 'edkolev/tmuxline.vim'
call plug#end()
" set
let g:toggleterm_terminal_mapping = '<A-t>'
" or manually...
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><A-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><A-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><A-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
"set shortmess-=F
syntax enable
colorscheme material
au ColorScheme * hi Normal ctermbg=none guibg=none
set background=dark
set t_Co=256
let g:gruvbox_contrast_dark = 'medium'
let g:material_theme_style = 'darker'
let ayucolor="dark"
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
nnoremap <leader>f <cmd>Files<cr>
nnoremap <leader>s <cmd>Ag<cr>
nnoremap <leader>b <cmd>Buffers<cr>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>m 	:Marks<CR>
nnoremap <leader>, :Maps<CR>
nnoremap <leader>t :TableModeToggle<CR>
nnoremap <leader>M 	<ESC>:delm!<bar>:delm A-Z0-9<bar>:wshada!<CR>
"------------------------------------------------------------------------------"
"                                   Nerdtree                                   "
"------------------------------------------------------------------------------"
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
 "If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
	\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
" Make nerdtree open on right side
let g:NERDTreeWinPos = "right"
nnoremap <A-b> :NERDTreeToggle<CR>
"------------------------------------------------------------------------------"
"                                 commets keys                                 "
"------------------------------------------------------------------------------"
let g:CommentFrame_SkipDefaultMappings = 1
map <leader>c' :CommentFrameQuoteDash ""<left>
map <leader>c/ :CommentFrameSlashes ""<left>
map <leader>ch :CommentFrameHashDash ""<left>
set background=dark 
"set termguicolors
let g:mkdp_auto_start = 1
set cursorline
highlight link javaIdentifier NONE
set path+=**					" Searches current directory recursively.
set wildmenu					" Display all matches when tab complete.
set incsearch                   " Incremental search
"set spell                       "spell checking
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set t_Co=256                    " Set if term supports 256 colors.
set number relativenumber       " Display line numbers
"set nowrap
"set nu nu
let g:livepreview_previewer = 'zathura'
map <A-q> :q!<CR>
map <A-w> :wq<CR>
set clipboard=unnamedplus       " Copy/paste between vim and other programs.
syntax enable
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
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
command! -nargs=0 Prettier :CocCommand prettier.formatFile
vmap <leader>,  <Plug>(coc-format-selected)
map <leader>/ <Plug>NERDCommenterToggle
nmap <silent><leader>r <plug>CodeRunner
let g:fzf_preview_command = 'bat --color=always --plain {-1}'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
"------------------------------------------------------------------------------"
"                               find and replace                               "
"------------------------------------------------------------------------------"
nnoremap <Leader>RRR
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" The same as above except it works with a visual selection.
xmap <Leader>RRR
    \ "sy
    \ gvgr
    \ :cfdo %s/<C-r>s//g \| update
     \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

"map s *
map <A-s> *
 " Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
"nnoremap <A-r> :%s///g<Left><Left>
nnoremap <A-r> :%s///gc<Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
xnoremap <A-r> :s///g<Left><Left>
"xnoremap <Leader>rc :s///gc<Left><Left><Left>                                                               
" => Vim-Instant-Markdown
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
 map <A-m> :MarkdownPreviewToggle<CR>   " Previews .md file
" => Text, tab and indent related
 "set expandtab                   " Use spaces instead of tabs.
 set smarttab                    " Be smart using tabs ;)
 set shiftwidth=4                " One tab == four spaces.
 set tabstop=4                   " One tab == four spaces.
 set mouse=nicr
 set splitbelow splitright
 map <A-H> :sp 
 map <A-v> :vs 
 " Remap splits navigation to just ctrl+ hjkl
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
noremap <A-Left> :vertical resize +3<CR>
noremap <A-Right> :vertical resize -3<CR>
noremap <A-Up> :resize +3<CR>
noremap <A-Down> :resize -3<CR>
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K
 let g:python_highlight_all = 1
"-----------------------------------------------------------
"make use of tab and shift tab 
"-----------------------------------------------------------
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"COC config
let g:coc_global_extentions = [
	\ 'coc-snippet',
	\ 'coc-tabnine',
	\ 'coc-prettier',
	\ 'coc-pairs',
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
	\]
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
"xmap <leader>F  <Plug>(coc-format-selected)
"nmap <leader>F  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
"nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)


" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"------------------------------------------------------------------------------"
"                                    airline                                   "
"------------------------------------------------------------------------------"
"enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#show_splits = 0
" enable powerline fonts
"let g:airline_powerline_fonts = 1
"let g:airline_left_sep = '>'
"let g:airline_right_sep = '<'
" Switch to your current theme
let g:airline_theme = 'minimalist'
"" Always show tabs
"set showtabline=2
 "We don't need to see things like -- INSERT -- anymore
set noshowmode
"------------------------------------------------------------------------------"
"                                 vim fugitive                                 "
"------------------------------------------------------------------------------"
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>
nmap <leader>gg :Git commit<CR>
nmap <leader>gp :Git push<CR>
"tmuxline
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"
set nocompatible
filetype plugin on
set tgc
let g:tmuxline_powerline_separators = 0
map j gj
map k gk
"map <A-a> 0
map <leader>a 0
map <leader>; $
"map <A-;> $
xnoremap <C-j> <C-n>
xnoremap <C-k> <C-p>
nnoremap <C-j> <C-n>
nnoremap <C-k> <C-p>
vnoremap <C-j> <C-n>
vnoremap <C-k> <C-p>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap gx <CMD>execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)<CR>
"hi MatchParen cterm=bold ctermbg=black ctermfg=blue
nnoremap Q <nop>
autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()
