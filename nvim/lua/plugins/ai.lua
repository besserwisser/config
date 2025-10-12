vim.pack.add({
	"https://github.com/folke/sidekick.nvim",
})

local sidekick = require("sidekick")
sidekick.setup()

vim.keymap.set({ "i", "n" }, "<tab>", function()
	-- if there is a next edit, jump to it, otherwise apply it if any
	if require("sidekick").nes_jump_or_apply() then
		return
	end
	-- if you are using Neovim's native inline completions
	if vim.lsp.inline_completion.get() then
		return
	end
	-- any other things (like snippets) you want to do on <tab> go here.
	-- fall back to normal tab
	return "<tab>"
end, { expr = true })
vim.keymap.set({ "n", "v" }, "<leader>aa", function()
	require("sidekick.cli").toggle({ focus = true, name = "copilot" })
end)
vim.keymap.set({ "n", "v" }, "<leader>ap", function()
	require("sidekick.cli").prompt()
end)
vim.keymap.set("t", "<C-w>p", function()
	require("sidekick.cli").focus({ focus = false })
end)

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
