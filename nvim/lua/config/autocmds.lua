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

-- Show cursor line only in the active window to make clear which window is active
local cursorline_group = vim.api.nvim_create_augroup("CursorLineOnlyInActiveWindow", {
	clear = true,
})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
	group = cursorline_group,
	pattern = "*",
	callback = function()
		vim.wo.cursorline = true -- 'vim.wo' is for window-local options
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = cursorline_group,
	pattern = "*",
	callback = function()
		vim.wo.cursorline = false
	end,
})
