return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	lazy = false, -- neo-tree will lazily load itself
	opts = {
		-- fill any relevant options here
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			window = {
				width = 28,
			},
		})
		vim.keymap.set("", "<leader>e", ":Neotree toggle <CR>", { silent = true })
	end,
}
