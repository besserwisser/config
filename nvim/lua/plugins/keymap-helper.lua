vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local which_key = require("which-key")

which_key.setup({
	preset = "helix",
	triggers = {
		{ "<auto>", mode = "nxso" },
		{ "a", mode = { "o", "x" } },
		{ "i", mode = { "o", "x" } },
		{ "[", mode = { "n", "x", "o" } },
		{ "]", mode = { "n", "x", "o" } },
	},
})

which_key.add({
	{ "a", group = "around", mode = { "o", "x" } },
	{ "i", group = "inside", mode = { "o", "x" } },
})
