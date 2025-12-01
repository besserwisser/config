vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local oil = require("oil")
oil.setup({
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
	oil.toggle_float()
end, { desc = "Toggle Oil float" })

-- Open preview window when entering Oil
vim.api.nvim_create_autocmd("User", {
	pattern = "OilEnter",
	callback = function()
		oil.open_preview()
	end,
})
