-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("VisualEffectYank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
	end,
})
