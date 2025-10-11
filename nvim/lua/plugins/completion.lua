vim.pack.add({ { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("^1") } })

require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 50,
		},
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
	},
	signature = {
		enabled = true,
		window = {
			show_documentation = true,
		},
	},
})
