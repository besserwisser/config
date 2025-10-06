vim.pack.add({
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/saxon1964/neovim-tips",
})

require("neovim_tips").setup({
	-- Path to user tips file
	user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",

	-- Prefix added to user tip titles to prevent conflicts
	user_tip_prefix = "[User] ",

	-- Show warnings when user tips have conflicting titles with builtin tips
	warn_on_conflicts = true,

	-- Daily tip mode: 0=off, 1=once per day, 2=every startup
	daily_tip = 2,
})
