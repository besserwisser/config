return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
			}
		})
		vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { desc = "Open CodeCompanion Chat" })
		vim.keymap.set("n", "<leader>ap", "<cmd>CodeCompanionActions<cr>", { desc = "Action Prompts" })
	end,
}
