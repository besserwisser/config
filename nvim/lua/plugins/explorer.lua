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

-- Keymap to toggle Oil float
vim.keymap.set("n", "<leader>e", function()
	oil.open_float(nil, { preview = {} })
end, { desc = "Toggle Oil" })

-- Hand pictures and pdfs to an external renderer (see config.utils). Oil keeps
-- its own preview for everything else, so code and text stay as they were.
local utils = require("config.utils")
require("oil.config").preview_win.disable_preview = utils.preview_handles

local orig_open_preview = oil.open_preview
oil.open_preview = function(opts, callback)
	orig_open_preview(opts, function(err)
		local entry, dir = oil.get_cursor_entry(), oil.get_current_dir()
		local win = require("oil.util").get_preview_win()
		local path = (not err and win and dir and entry and entry.type == "file")
			and vim.fs.joinpath(dir, entry.name)
			or nil

		if path and utils.preview_handles(path) then
			local buf = vim.api.nvim_create_buf(false, true)
			vim.bo[buf].bufhidden = "wipe"
			vim.api.nvim_win_set_buf(win, buf) -- blank canvas; the image goes on top
			utils.preview_file(path, win)
		else
			utils.clear_image_overlay()
		end
		if callback then
			callback(err)
		end
	end)
end
