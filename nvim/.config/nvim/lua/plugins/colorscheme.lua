return {
	"vague2k/vague.nvim",
	config = function()
		-- NOTE: you do not need to call setup if you don't want to.
		require("vague").setup({
			-- optional configuration here
			transparent = true, -- don't set background
		})
		vim.cmd.colorscheme("vague")
	end,
}
