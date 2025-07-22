return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		opts = {}
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls", "ts_ls", "eslint"
			}
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			lspconfig.ts_ls.setup({
				capabilities = capabilities
			})
			lspconfig.eslint.setup({
				settings = {
					rulesCustomizations = {
						-- https://github.com/import-js/eslint-plugin-import/issues/1913
						{ rule = "import/no-extraneous-dependencies", severity = "off" },
					},
				},
				on_attach = function()
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = "*.tsx,*.ts,*.jsx,*.js",
						callback = function()
							vim.cmd([[EslintFixAll]])
						end,
					})
				end
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = 'LuaJIT',
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								'vim',
								'require'
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				}
			})
		end,
	},
}
