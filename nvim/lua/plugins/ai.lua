vim.keymap.set("i", "<Tab>", function()
	if not vim.lsp.inline_completion.get() then
		return "<Tab>"
	end
end, { expr = true, desc = "Accept the current inline completion" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableInlineCompletion", { clear = true }),
	callback = function()
		-- Disable inline completion for leetcode project
		local cwd = vim.fn.getcwd()
		if cwd:match("Dev/Private/leetcode") then
			return
		end
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
