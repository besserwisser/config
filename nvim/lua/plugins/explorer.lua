-- Nvim 0.13 ships a builtin directory browser (`:help dir`). It is a netrw
-- replacement, not a file manager: the listing is read-only and provides no
-- actions that touch the filesystem. oil.nvim does both.
--
-- The two would fight over directory buffers -- oil disables netrw itself
-- (see config.options), but not the builtin `dir` plugin, which keeps its
-- own autocommands in `nvim.dir` regardless. Take it out explicitly -- this
-- has to happen before Nvim sources its runtime plugins.
vim.g.loaded_nvim_dir_plugin = true

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local oil = require("oil")

oil.setup({
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
	},

	keymaps = {
		-- Close Oil
		["<Esc>"] = {
			"actions.close",
			mode = "n",
		},
		-- Preview scrolling
		["<C-f>"] = "actions.preview_scroll_down",
		["<C-b>"] = "actions.preview_scroll_up",
	},
})

-- Hand images to snacks.image (configured in plugins/fuzzy-find.lua) instead
-- of oil's own preview, which would just dump the raw bytes as text. Oil
-- keeps its normal preview for everything else.
require("oil.config").preview_win.disable_preview = function(path)
	return Snacks.image.supports_file(path)
end

local orig_open_preview = oil.open_preview
oil.open_preview = function(opts, callback)
	orig_open_preview(opts, function(err)
		local entry, dir = oil.get_cursor_entry(), oil.get_current_dir()
		local win = require("oil.util").get_preview_win()
		local path = (not err and win and dir and entry and entry.type == "file")
			and vim.fs.joinpath(dir, entry.name)
			or nil

		if path and Snacks.image.supports_file(path) then
			local buf = vim.api.nvim_create_buf(false, true)
			vim.bo[buf].bufhidden = "wipe" -- snacks cleans up the placement on wipe
			vim.api.nvim_win_set_buf(win, buf) -- blank canvas; the image goes on top
			Snacks.image.buf.attach(buf, { src = path })
		end
		if callback then
			callback(err)
		end
	end)
end

vim.keymap.set("n", "<leader>e", function()
	oil.open_float(nil, { preview = {} })
end, { desc = "Toggle Oil" })
