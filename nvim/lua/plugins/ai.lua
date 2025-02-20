vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/CopilotC-Nvim/CopilotChat.nvim",
})

local copilot_chat = require("CopilotChat")

copilot_chat.setup({})

vim.keymap.set({ "n", "v" }, "<leader>aa", function()
	copilot_chat.open()
end)
vim.keymap.set({ "n", "v" }, "<leader>ap", function()
	copilot_chat.select_prompt()
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableInlineCompletion", { clear = true }),
	callback = function()
		-- Enable LLM-based inline completion
		vim.lsp.inline_completion.enable(true)
		vim.keymap.set({ "i", "n" }, "<C-j>", function()
			vim.lsp.inline_completion.get()
		end)
		vim.keymap.set("i", "<C-;>", function()
			vim.lsp.inline_completion.select()
		end)
		vim.keymap.set("i", "<C-,>", function()
			vim.lsp.inline_completion.select({ count = -1 })
		end)
	end,
})
