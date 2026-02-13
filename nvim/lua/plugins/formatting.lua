vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	format_on_save = {
		lsp_format = "first",
		timeout_ms = 3000,
	},
	formatters = {
		prettierd = {
			-- Only format if a config file is present in the cwd
			require_cwd = true,
			cwd = require("conform.util").root_file({
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
				"prettier.config.ts",
			}),
		},
	},
	formatters_by_ft = {
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		lua = { "stylua" },
		json = { "prettierd" },
		markdown = { "prettierd" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
