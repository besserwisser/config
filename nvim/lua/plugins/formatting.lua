vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	format_on_save = {
		lsp_format = "first",
		timeout_ms = 1000,
	},
	formatters_by_ft = {
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		lua = { "stylua" },
		markdown = { "prettierd" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
