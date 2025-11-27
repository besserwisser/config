vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local oil = require("oil")
oil.setup({
	keymaps = {
		["<Esc>"] = "actions.close",
		mode = "n",
	},
})

vim.keymap.set("n", "<leader>e", function()
	oil.toggle_float()
end, { desc = "Toggle Oil float" })
