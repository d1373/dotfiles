return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				path = "~/Notes",
			},
		},
		notes_subdir = nil,
		new_notes_location = "current_dir",

		-- Disable obsidian's own rendering since you have render-markdown
		ui = {
			enable = false, -- Let render-markdown handle the UI
		},

		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["gk"] = {
				action = function()
					return require("obsidian").util.follow_url_func()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
		},
	},
}
