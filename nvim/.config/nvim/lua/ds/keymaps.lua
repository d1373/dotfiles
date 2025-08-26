vim.g.mapleader = " "
vim.g.maplocalleader = " "
local opts = { noremap = true, silent = true }

-- Custom buffer-close function
local function close_buffer_or_vim(force)
	local listed_buffers = vim.tbl_filter(function(bufnr)
		return vim.fn.buflisted(bufnr) == 1
	end, vim.api.nvim_list_bufs())

	if #listed_buffers == 1 then
		vim.cmd("quit" .. (force and "!" or ""))
	else
		vim.cmd("bdelete" .. (force and "!" or ""))
	end
end

-- Key mappings
vim.keymap.set("n", "<Leader>q", function()
	close_buffer_or_vim(false)
end, { silent = true })
vim.keymap.set("n", "<Leader>Q", function()
	close_buffer_or_vim(true)
end, { silent = true })
vim.keymap.set("", "q", "<Nop>")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<M-h>", "0")
vim.keymap.set("n", "<M-l>", "$")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("", "<C-b>", ":vs<CR>", { silent = true })
vim.keymap.set("", "<M-Left>", ":vertical resize +3<CR>", { silent = true })
vim.keymap.set("", "<M-Right>", ":vertical resize -3<CR>", { silent = true })
vim.keymap.set("", "<M-Up>", ":resize +3<CR>", { silent = true })
vim.keymap.set("", "<M-Down>", ":resize -3<CR>", { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("v", "d", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "<M-r>", ":source ~/.config/nvim/init.lua", { silent = true })
