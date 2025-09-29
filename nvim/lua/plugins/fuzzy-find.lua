vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/folke/snacks.nvim",
})

local snacks = require("snacks")

snacks.setup({
	picker = {
		ui_select = true,
		formatters = {
			file = {
				truncate = 100,
				filename_first = true,
			},
		},
		sources = {
			explorer = {
				layout = {
					preset = "telescope",
					preview = true,
				},
				auto_close = true,
			},
			recent = {
				filter = {
					cwd = true,
				},
			},
		},
	},
})

local keymap = vim.keymap.set


-- stylua: ignore start
-- Top Pickers & Explorer
keymap("n", "<leader><space>", function() snacks.picker.smart() end, { desc = "Smart Find Files" })
keymap("n", "<leader>,", function() snacks.picker.buffers() end, { desc = "Buffers" })
keymap("n", "<leader>/", function() snacks.picker.grep() end, { desc = "Grep" })
keymap("n", "<leader>:", function() snacks.picker.command_history() end, { desc = "Command History" })
keymap("n", "<leader>n", function() snacks.picker.notifications() end, { desc = "Notification History" })
keymap("n", "<leader>e", function() snacks.explorer() end, { desc = "File Explorer" })

-- find
keymap("n", "<leader>fb", function() snacks.picker.buffers() end, { desc = "Buffers" })
keymap("n", "<leader>fc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
	{ desc = "Find Config File" })
keymap("n", "<leader>ff", function() snacks.picker.files() end, { desc = "Find Files" })
keymap("n", "<leader>fg", function() snacks.picker.git_files() end, { desc = "Find Git Files" })
keymap("n", "<leader>fp", function() snacks.picker.projects() end, { desc = "Projects" })
keymap("n", "<leader>fr", function() snacks.picker.recent() end, { desc = "Recent" })

-- git
keymap("n", "<leader>gb", function() snacks.picker.git_branches() end, { desc = "Git Branches" })
keymap("n", "<leader>gl", function() snacks.picker.git_log() end, { desc = "Git Log" })
keymap("n", "<leader>gL", function() snacks.picker.git_log_line() end, { desc = "Git Log Line" })
keymap("n", "<leader>gs", function() snacks.picker.git_status() end, { desc = "Git Status" })
keymap("n", "<leader>gS", function() snacks.picker.git_stash() end, { desc = "Git Stash" })
keymap("n", "<leader>gd", function() snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
keymap("n", "<leader>gf", function() snacks.picker.git_log_file() end, { desc = "Git Log File" })

-- Grep
keymap("n", "<leader>sb", function() snacks.picker.lines() end, { desc = "Buffer Lines" })
keymap("n", "<leader>sB", function() snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
keymap("n", "<leader>sg", function() snacks.picker.grep() end, { desc = "Grep" })
keymap({ "n", "x" }, "<leader>sw", function() snacks.picker.grep_word() end, { desc = "Visual selection or word" })

-- search
keymap("n", '<leader>s"', function() snacks.picker.registers() end, { desc = "Registers" })
keymap("n", '<leader>s/', function() snacks.picker.search_history() end, { desc = "Search History" })
keymap("n", "<leader>sa", function() snacks.picker.autocmds() end, { desc = "Autocmds" })
keymap("n", "<leader>sb", function() snacks.picker.lines() end, { desc = "Buffer Lines" })
keymap("n", "<leader>sc", function() snacks.picker.command_history() end, { desc = "Command History" })
keymap("n", "<leader>sC", function() snacks.picker.commands() end, { desc = "Commands" })
keymap("n", "<leader>sd", function() snacks.picker.diagnostics() end, { desc = "Diagnostics" })
keymap("n", "<leader>sD", function() snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
keymap("n", "<leader>sh", function() snacks.picker.help() end, { desc = "Help Pages" })
keymap("n", "<leader>sH", function() snacks.picker.highlights() end, { desc = "Highlights" })
keymap("n", "<leader>si", function() snacks.picker.icons() end, { desc = "Icons" })
keymap("n", "<leader>sj", function() snacks.picker.jumps() end, { desc = "Jumps" })
keymap("n", "<leader>sk", function() snacks.picker.keymaps() end, { desc = "Keymaps" })
keymap("n", "<leader>sl", function() snacks.picker.loclist() end, { desc = "Location List" })
keymap("n", "<leader>sm", function() snacks.picker.marks() end, { desc = "Marks" })
keymap("n", "<leader>sM", function() snacks.picker.man() end, { desc = "Man Pages" })
keymap("n", "<leader>sp", function() snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
keymap("n", "<leader>sq", function() snacks.picker.qflist() end, { desc = "Quickfix List" })
keymap("n", "<leader>sR", function() snacks.picker.resume() end, { desc = "Resume" })
keymap("n", "<leader>su", function() snacks.picker.undo() end, { desc = "Undo History" })
keymap("n", "<leader>uC", function() snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- LSP
keymap("n", "gd", function() snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
keymap("n", "grr", function() snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
keymap("n", "gri", function() snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
keymap("n", "grt", function() snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
keymap("n", "gO", function() snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })

-- stylua: ignore end
