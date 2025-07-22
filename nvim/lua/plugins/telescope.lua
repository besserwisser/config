return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
		},
		{ 'nvim-tree/nvim-web-devicons' },
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	keys = {
		{ '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>',                       desc = 'Find Files' },
		{ '<leader>fg', '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', desc = 'Live Grep' },
		{ '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>',                          desc = 'Find Buffers' },
		{ '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>',                        desc = 'Help Tags' },
		{ '<leader>fr', '<cmd>lua require("telescope.builtin").oldfiles()<CR>',                         desc = 'Recent Files' },
	},
	config = function()
		local telescope = require("telescope")

		local actions = require("telescope.actions")

		local lga_actions = require("telescope-live-grep-args.actions")

		-- first setup telescope
		telescope.setup({
			defaults = {
				mappings = {
					["i"] = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							-- There are more options like "-i" to ignore case or "--no-ignore"
							["<C-k>"] = lga_actions.quote_prompt({ postfix = " --type ts" }),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							-- iglob with buffer folder string
							["<C-o>"] = function(prompt_bufnr)
								local buffer_folder_path = vim.fn.expand("#")
								local first_two_segments = buffer_folder_path:match("^([^/]+/[^/]+)/")
								local first_segment = buffer_folder_path:match("^([^/]+)/")
								local iglob
								if first_two_segments then
									iglob = " --iglob " .. first_two_segments .. "/**"
								elseif first_segment then
									iglob = " --iglob " .. first_segment .. "/**"
								else
									iglob = " --iglob /**"
								end
								lga_actions.quote_prompt({ postfix = iglob })(prompt_bufnr)
							end,
							-- exclude spec.ts files
							["<C-l>"] = lga_actions.quote_prompt({ postfix = " --iglob !*.spec.ts" }),
						},
					},
				},
			},
		})

		-- then load the extension
		telescope.load_extension("live_grep_args")
		telescope.load_extension("fzf")
	end,
}
