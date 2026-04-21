vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 3000,
	},
	formatters_by_ft = {
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		lua = { "stylua" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
