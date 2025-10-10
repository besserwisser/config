local utils = require("config.utils")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("VisualEffectYank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
	end,
})

-- Create the autocommand that calls our function
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("Dashboard", { clear = true }),
	callback = utils.show_tip,
	desc = "Show custom dashboard on startup",
})
