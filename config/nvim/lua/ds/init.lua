require("ds.map")
require("ds.pckr")
require("ds.plugset")
require("ds.set")


-- NETRW basic Set
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
-- WSL Yank Support
vim.cmd([[
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
	augroup WSLYank
			autocmd!
			autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
	augroup END
endif
]])
