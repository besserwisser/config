return {
	"github/copilot.vim",
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },                    -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken",                       -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		keys = {
			{ "<leader>aa", "<cmd>CopilotChatOpen<cr>",    desc = "Copilot Open" },
			{ "<leader>ag", "<cmd>CopilotChatAgents<cr>",  desc = "Copilot Chat Agents" },
			{ "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "Copilot Chat Prompts" },
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
