vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

local nvim_treesitter_configs = require("nvim-treesitter.configs")

nvim_treesitter_configs.setup({
	ensure_installed = {
		"lua",
		"javascript",
		"typescript",
		"tsx",
		"json",
		"css",
		"html",
		"http",
		"diff",
		"vue",
		"regex",
		"terraform",
	},
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
	modules = {},
	sync_install = false,
	ignore_install = {},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["am"] = "@function.outer",
				["im"] = "@function.inner",
				["al"] = "@class.outer",
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				["il"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["ad"] = "@conditional.outer",
				["id"] = "@conditional.inner",
				["ao"] = "@loop.outer",
				["io"] = "@loop.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@call.outer",
				["if"] = "@call.inner",
				["ac"] = "@comment.outer",
				["ar"] = "@frame.outer",
				["ir"] = "@frame.inner",
				["at"] = "@attribute.outer",
				["it"] = "@attribute.inner",
				["ae"] = "@scopename.inner",
				["ie"] = "@scopename.inner",
				["as"] = "@statement.outer",
				["is"] = "@statement.outer",
			},
			selection_modes = {
				["@function.outer"] = "V", -- linewise
			},
			-- You can choose the select mode (default is charwise 'v')
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			-- selection_modes = treesitter_selection_mode,
			-- if you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true of false
			include_surrounding_whitespace = false,
		},
		swap = {
			enable = true,
			swap_next = {
				[")m"] = "@function.outer",
				[")c"] = "@comment.outer",
				[")a"] = "@parameter.inner",
				[")b"] = "@block.outer",
				[")C"] = "@class.outer",
			},
			swap_previous = {
				["(m"] = "@function.outer",
				["(c"] = "@comment.outer",
				["(a"] = "@parameter.inner",
				["(b"] = "@block.outer",
				["(C"] = "@class.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]f"] = "@call.outer",
				["]o"] = "@loop.outer",
				["]s"] = "@statement.outer",
				["]a"] = "@parameter.outer",
				["]c"] = "@comment.outer",
				["]b"] = "@block.outer",
				["]l"] = { query = "@class.outer", desc = "next class start" },
				["]r"] = "@frame.outer",
				["]t"] = "@attribute.outer",
				["]e"] = "@scopename.outer",
				["]]m"] = "@function.inner",
				["]]f"] = "@call.inner",
				["]]d"] = "@conditional.inner",
				["]]o"] = "@loop.inner",
				["]]a"] = "@parameter.inner",
				["]]b"] = "@block.inner",
				["]]l"] = { query = "@class.inner", desc = "next class start" },
				["]]r"] = "@frame.inner",
				["]]t"] = "@attribute.inner",
				["]]e"] = "@scopename.inner",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]F"] = "@call.outer",
				["]D"] = "@conditional.outer",
				["]O"] = "@loop.outer",
				["]S"] = "@statement.outer",
				["]A"] = "@parameter.outer",
				["]C"] = "@comment.outer",
				["]B"] = "@block.outer",
				["]L"] = "@class.outer",
				["]R"] = "@frame.outer",
				["]T"] = "@attribute.outer",
				["]E"] = "@scopename.outer",
				["]]M"] = "@function.inner",
				["]]F"] = "@call.inner",
				["]]D"] = "@conditional.inner",
				["]]O"] = "@loop.inner",
				["]]A"] = "@parameter.inner",
				["]]B"] = "@block.inner",
				["]]L"] = "@class.inner",
				["]]R"] = "@frame.inner",
				["]]T"] = "@attribute.inner",
				["]]E"] = "@scopename.inner",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[f"] = "@call.outer",
				["[o"] = "@loop.outer",
				["[s"] = "@statement.outer",
				["[a"] = "@parameter.outer",
				["[c"] = "@comment.outer",
				["[b"] = "@block.outer",
				["[l"] = "@class.outer",
				["[r"] = "@frame.outer",
				["[t"] = "@attribute.outer",
				["[e"] = "@scopename.outer",
				["[[m"] = "@function.inner",
				["[[f"] = "@call.inner",
				["[[d"] = "@conditional.inner",
				["[[o"] = "@loop.inner",
				["[[a"] = "@parameter.inner",
				["[[b"] = "@block.inner",
				["[[l"] = "@class.inner",
				["[[r"] = "@frame.inner",
				["[[t"] = "@attribute.inner",
				["[[e"] = "@scopename.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[F"] = "@call.outer",
				["[D"] = "@conditional.outer",
				["[O"] = "@loop.outer",
				["[S"] = "@statement.outer",
				["[A"] = "@parameter.outer",
				["[C"] = "@comment.outer",
				["[B"] = "@block.outer",
				["[L"] = "@class.outer",
				["[R"] = "@frame.outer",
				["[T"] = "@attribute.outer",
				["[E"] = "@scopename.outer",
				["[[M"] = "@function.inner",
				["[[F"] = "@call.inner",
				["[[D"] = "@conditional.inner",
				["[[O"] = "@loop.inner",
				["[[A"] = "@parameter.inner",
				["[[B"] = "@block.inner",
				["[[L"] = "@class.inner",
				["[[R"] = "@frame.inner",
				["[[T"] = "@attribute.inner",
				["[[E"] = "@scopename.inner",
			},
		},
	},
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- run :TSUpdate when plugin is updated
vim.api.nvim_create_autocmd({ "PackChanged" }, {
	group = vim.api.nvim_create_augroup("TreesitterUpdated", { clear = true }),
	callback = function(args)
		local spec = args.data.spec
		if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
			vim.notify("nvim-treesitter was updated, running :TSUpdate", vim.log.levels.INFO)
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end
	end,
})

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
