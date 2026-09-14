-- Nvim 0.13 ships a builtin directory browser (`:help dir`). It is a netrw
-- replacement, not a file manager: the listing is read-only and provides no
-- actions that touch the filesystem. Snacks' explorer does both, and being a
-- picker it previews images through the same path the pickers do.
--
-- The two would fight over directory buffers. Snacks disables netrw by deleting
-- the `FileExplorer` augroup, but the builtin only creates that one for
-- backwards compatibility and keeps its own autocommands in `nvim.dir`, so it
-- survives. Take it out explicitly -- this has to happen before Nvim sources its
-- runtime plugins.
vim.g.loaded_nvim_dir_plugin = true

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/folke/snacks.nvim",
})

---@type Snacks
local snacks = require("snacks")

snacks.setup({
	toggle = {},
	explorer = {},
	-- iTerm2 speaks the kitty graphics protocol -- placements and deletes both
	-- work -- but it is not in snacks' terminal list (snacks/image/terminal.lua),
	-- so detection has to be overridden. `force` skips it entirely; because no
	-- environment then matches, `placeholders` stays off, which is what we want:
	-- unicode placeholders are a kitty extension iTerm2 does not have, and snacks
	-- falls back to positioning the image over the window instead.
	image = {
		enabled = true,
		force = true,
		-- snacks' default list, plus the three this config previewed before and
		-- snacks does not list: svg, ico, and tif (it only has tiff).
		-- stylua: ignore
		formats = {
			"png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "tif",
			"heic", "avif", "svg", "ico", "pdf", "icns",
			"mp4", "mov", "avi", "mkv", "webm",
		},
	},
	picker = {
		ui_select = true,
		win = {
			input = {
				keys = {
					["<C-n>"] = { "history_forward", mode = { "i", "n" } },
					["<C-p>"] = { "history_back", mode = { "i", "n" } },
				},
			},
		},
		formatters = {
			file = {
				truncate = 100,
				filename_first = true,
			},
		},
		sources = {
			explorer = {
				-- Defaults to a sidebar with the preview switched off. Neither
				-- suits here: this is the float, and the preview is what makes
				-- images show up at all (see `image` above).
				layout = { preset = "telescope", preview = true },
				-- The explorer defaults both of these to false, on the
				-- assumption that it is a persistent sidebar you keep
				-- browsing in. In a float that just leaves it sitting open
				-- over the buffer you asked to open, needing a manual <Esc>.
				-- Only files are affected -- opening a directory goes through
				-- `Tree:toggle` instead of this at all (explorer/actions.lua),
				-- so it still expands in place regardless of this setting.
				auto_close = true,
				jump = { close = true },
			},
			smart = {
				multi = { "recent", "files" },
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
keymap("n", "<leader>e", function() snacks.explorer() end, { desc = "File Explorer" })
keymap("n", "<leader><space>", function() snacks.picker.smart() end, { desc = "Smart Find Files" })
keymap("n", "<leader>,", function() snacks.picker.buffers() end, { desc = "Buffers" })
keymap("n", "<leader>/", function() snacks.picker.grep() end, { desc = "Grep" })
keymap("n", "<leader>:", function() snacks.picker.command_history() end, { desc = "Command History" })
keymap("n", "<leader>n", function() snacks.picker.notifications() end, { desc = "Notification History" })

-- find
keymap("n", "<leader>fb", function() snacks.picker.buffers() end, { desc = "Buffers" })
keymap("n", "<leader>fB", function() snacks.picker.buffers({ modified = true }) end, { desc = "Modified Buffers" })
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
keymap("n", "<leader>gd", function() snacks.picker.git_diff({ group = true }) end, { desc = "Git Diff (Hunks)" })
keymap("n", "<leader>gD", function() snacks.picker.git_diff({ base = "main", group = true }) end, { desc = "Git Diff vs Main" })
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
