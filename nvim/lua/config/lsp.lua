vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.config("eslint", {
	settings = {
		rulesCustomizations = {
			{ rule = "import/no-extraneous-dependencies", severity = "off" },
		},
	},
})

vim.lsp.config("copilot", {
	settings = {
		telemetry = {
			telemetryLevel = "off",
		},
	},
})

vim.lsp.config("vtsls", {
	settings = {
		vtsls = {
			tsserver = {
				-- activate again if: https://github.com/vuejs/language-tools/pull/5869 is released
				-- globalPlugins = {
				-- 	{
				-- 		name = "@vue/typescript-plugin",
				-- 		location = vim.fn.stdpath("data")
				-- 			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
				-- 		languages = { "vue" },
				-- 		configNamespace = "typescript",
				-- 	},
				-- },
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
})

-- For now I use vtsls over tsgo, because vtsls supports Vue files. Also tsgo did not work with file completion in import/export statements.
vim.lsp.enable({ "vtsls", "lua_ls", "eslint", "vue_ls", "copilot", "terraformls" })
