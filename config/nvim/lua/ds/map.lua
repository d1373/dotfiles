vim.cmd[[
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
map j gj
map k gk
nnoremap Q <nop>
map <leader>N :tabnew<CR> 
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
map <leader>/ <Plug>NERDCommenterToggle
map <leader>a 0
map <leader>; $
map <C-l> :bnext<CR>
map <C-h> :bprev<CR>
map <leader>h :tabp<CR>
map <leader>l :tabn<CR>
xnoremap <C-j> <C-n>
xnoremap <C-k> <C-p>
nnoremap <C-j> <C-n>
nnoremap <C-k> <C-p>
vnoremap <C-j> <C-n>
vnoremap <C-k> <C-p>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
nnoremap <C-b> :NvimTreeToggle<CR>
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
 
]]
