return {
	"github/copilot.vim",
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {},
		keys = {
			{ "<leader>aa", "<cmd>CopilotChatOpen<cr>", desc = "CopilotChatOpen" },
			{ "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "CopilotChatPrompts" },
		},
	},
}
