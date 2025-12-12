vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local oil = require("oil")
oil.setup({
	skip_confirm_for_simple_edits = true,
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
	oil.open_float()
end, { desc = "Toggle Oil" })

-- Open preview window when entering Oil
-- https://github.com/stevearc/oil.nvim/issues/87#issuecomment-2179322405
vim.api.nvim_create_autocmd("User", {
	pattern = "OilEnter",
	callback = vim.schedule_wrap(function(args)
		if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
			oil.open_preview()
		end
	end),
})
