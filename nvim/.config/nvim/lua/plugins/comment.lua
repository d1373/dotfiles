return {
	"preservim/nerdcommenter",
	lazy = false,
	priority = 1000,
	config = function()
		vim.keymap.set("n", "<M-/>", "<Plug>NERDCommenterToggle", { desc = "Toggle comment" })
	end,
}
