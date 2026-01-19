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
	oil.open_float(nil, { preview = {} })
end, { desc = "Toggle Oil" })
