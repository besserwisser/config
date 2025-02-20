vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
	"https://github.com/nvim-telescope/telescope-file-browser.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/natecraddock/telescope-zf-native.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
})

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

-- first setup telescope
telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.5,
				width = 0.9,
			},
		},

		mappings = {
			["i"] = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
				["<C-s>"] = actions.cycle_previewers_next,
				["<C-a>"] = actions.cycle_previewers_prev,
			},
		},
	},
	extensions = {
		["zf-native"] = {
			-- options for sorting file-like items
			file = {
				-- override default telescope file sorter
				enable = true,

				-- highlight matching text in results
				highlight_results = true,

				-- enable zf filename match priority
				match_filename = true,

				-- optional function to define a sort order when the query is empty
				initial_sort = nil,

				-- set to false to enable case sensitive matching
				smart_case = true,
			},

			-- options for sorting all other items
			generic = {
				-- override default telescope generic item sorter
				enable = true,

				-- highlight matching text in results
				highlight_results = true,

				-- disable zf filename match priority
				match_filename = false,

				-- optional function to define a sort order when the query is empty
				initial_sort = nil,

				-- set to false to enable case sensitive matching
				smart_case = true,
			},
		},
		live_grep_args = {
			auto_quoting = true,
			mappings = {
				i = {
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					-- There are more options like "-i" to ignore case or "--no-ignore"
					["<C-t>"] = lga_actions.quote_prompt({ postfix = " --type ts" }),
					-- iglob with folder of most recent project file, relevant for monorepos
					["<C-a>"] = function(prompt_bufnr)
						-- Find package.json by searching upwards from the current directory
						local current_buffer_dir = vim.fn.expand("#:p:h")
						local stop_dir = vim.fn.getcwd()
						local found_project_file = vim.fs.find({ "package.json" }, {
							path = current_buffer_dir,
							upward = true,
							stop = stop_dir,
						})[1]
						local project_dir = found_project_file and vim.fn.fnamemodify(found_project_file, ":h") or nil
						local relative_project_dir = project_dir and vim.fn.fnamemodify(project_dir, ":.") or nil

						if relative_project_dir then
							-- Get the directory of the found package.json file
							lga_actions.quote_prompt({ postfix = " --iglob " .. relative_project_dir .. "/**" })(
								prompt_bufnr
							)
						else
							print("No package.json found in parent directories.")
						end
					end,
					-- exclude spec.ts files
					["<C-s>"] = lga_actions.quote_prompt({ postfix = " --iglob !*.spec.ts" }),
				},
			},
		},
		["ui-select"] = {
			layout_strategy = "bottom_pane",
			layout_config = {
				height = 20,
			},
		},
	},
})
telescope.load_extension("zf-native")
telescope.load_extension("live_grep_args")
telescope.load_extension("file_browser")
telescope.load_extension("ui-select")

vim.keymap.set("n", "<leader>ff", function()
	telescope_builtin.find_files({
		hidden = true,
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"--glob=!.git/**",
			"--glob=!node_modules/**",
			"--glob=!tmp/**",
		},
	})
end)

vim.keymap.set("n", "<leader>fg", function()
	telescope.extensions.live_grep_args.live_grep_args({
		additional_args = function()
			return { "--hidden" }
		end,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--glob=!.git/**",
			"--glob=!node_modules/**",
			"--glob=!tmp/**",
		},
	})
end)

vim.keymap.set({ "n", "v" }, "<leader>fs", function()
	telescope_builtin.grep_string()
end)

vim.keymap.set("n", "<leader>fb", function()
	telescope_builtin.buffers()
end)

vim.keymap.set("n", "<leader>fh", function()
	telescope_builtin.help_tags()
end)

vim.keymap.set("n", "<leader>fo", function()
	telescope_builtin.oldfiles({
		only_cwd = true,
	})
end)

vim.keymap.set("n", "<leader>fk", function()
	telescope_builtin.keymaps()
end)

vim.keymap.set("n", "<leader>fr", function()
	telescope_builtin.lsp_references()
end)

vim.keymap.set("n", "<leader>gs", function()
	telescope_builtin.git_status()
end)

vim.keymap.set("n", "<leader>gb", function()
	telescope_builtin.git_branches()
end)

vim.keymap.set("n", "<leader>gc", function()
	telescope_builtin.git_bcommits()
end)

vim.keymap.set("n", "<leader>gl", function()
	telescope_builtin.git_bcommits_range()
end)

vim.keymap.set("n", "<space>fb", function()
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		select_buffer = true,
	})
end)
