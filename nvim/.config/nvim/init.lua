require("ds")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.colorscheme"),
	require("plugins.neotree"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.autoformat"),
	require("plugins.comment"),
	require("plugins.misc"),
	require("plugins.surround"),
	require("plugins.find"),
	require("plugins.harpoon"),
	require("plugins.lsp"),
	require("plugins.autocomplete"),
	require("plugins.noice"),
	require("plugins.indent"),
	require("plugins.supermaven"),
	require("plugins.alpha"),
	require("plugins.avante"),
	require("plugins.claude"),
	require("plugins.markdown"),
})
