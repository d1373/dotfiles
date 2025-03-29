-- Fuzzy Finder (files, lsp, etc)
return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"debugloop/telescope-undo.nvim",
		-- Useful for getting pretty icons, but requires a Nerd Font.
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-l>"] = actions.select_default, -- open file
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					hidden = true,
				},
				buffers = {
					initial_mode = "normal",
					sort_lastused = true,
					-- sort_mru = true,
					mappings = {
						n = {
							["d"] = actions.delete_buffer,
							["l"] = actions.select_default,
						},
					},
				},
			},
			live_grep = {
				file_ignore_patterns = { "node_modules", ".git", ".venv" },
				additional_args = function(_)
					return { "--hidden" }
				end,
			},
			path_display = {
				filename_first = {
					reverse_directories = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
			git_files = {
				previewer = false,
			},
		})

		-- Enable telescope fzf native, if installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		require("telescope").load_extension("undo")

		vim.keymap.set("n", "<leader>gf", "<cmd>Telescope git_files theme=ivy<cr>", { desc = "Search [G]it [F]iles" })
		vim.keymap.set(
			"n",
			"<leader>gc",
			"<cmd>Telescope git_commits theme=ivy<cr>",
			{ desc = "Search [G]it [C]ommits" }
		)
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Search [G]it [B]ranches" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Search [G]it [S]tatus (diff view)" })
		vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files theme=ivy<cr>", { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>j", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set(
			"n",
			"<leader>w",
			"<cmd>Telescope grep_string theme=ivy<cr>",
			{ desc = "[S]earch current [W]ord" }
		)
		vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep theme=ivy<cr>", { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>ss", "<cmd>Telescope spell_suggest theme=cursor<cr>", { desc = "[S]pell suggest" })
		vim.keymap.set("n", "<M-o>", "<cmd>Telescope undo theme=ivy<cr>", { desc = "[U]ndo" })
	end,
}
