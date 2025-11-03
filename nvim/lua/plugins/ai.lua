vim.keymap.set({ "i", "n" }, "<tab>", function()
	-- if you are using Neovim's native inline completions
	if vim.lsp.inline_completion.get() then
		return
	end
	-- any other things (like snippets) you want to do on <tab> go here.
	-- fall back to normal tab
	return "<tab>"
end, { expr = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableInlineCompletion", { clear = true }),
	callback = function()
		-- Enable LLM-based inline completion
		vim.lsp.inline_completion.enable(true)
		vim.keymap.set("i", "<C-;>", function()
			vim.lsp.inline_completion.select()
		end)
		vim.keymap.set("i", "<C-,>", function()
			vim.lsp.inline_completion.select({ count = -1 })
		end)
	end,
})
