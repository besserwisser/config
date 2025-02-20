vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

local mason = require("mason")
local mason_tool_installer = require("mason-tool-installer")

mason.setup()
mason_tool_installer.setup({
	ensure_installed = {
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"js-debug-adapter",
		"prettierd",
		"stylua",
		"tree-sitter-cli",
		"vue-language-server",
		"copilot-language-server",
	},
})
