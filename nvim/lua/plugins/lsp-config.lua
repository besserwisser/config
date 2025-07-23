-- https://github.com/nvim-telescope/telescope.nvim/issues/3328
local function filterDuplicates(array)
	local uniqueArray = {}
	for _, tableA in ipairs(array) do
		local isDuplicate = false
		for _, tableB in ipairs(uniqueArray) do
			if vim.deep_equal(tableA, tableB) then
				isDuplicate = true
				break
			end
		end
		if not isDuplicate then
			table.insert(uniqueArray, tableA)
		end
	end
	return uniqueArray
end

local function on_list(options)
	options.items = filterDuplicates(options.items)
	vim.fn.setqflist({}, " ", options)
	vim.cmd("botright copen")
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		opts = {},
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
				"lua_ls",
				"ts_ls",
				"eslint",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "vim.lsp.buf.definition" })
			vim.keymap.set("n", "grr", function()
				vim.lsp.buf.references(nil, { on_list = on_list })
			end, { desc = "vim.lsp.buf.references" })

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.eslint.setup({
				settings = {
					rulesCustomizations = {
						-- https://github.com/import-js/eslint-plugin-import/issues/1913
						{ rule = "import/no-extraneous-dependencies", severity = "off" },
					},
				},
				on_attach = function()
					vim.keymap.set("n", "gre", function()
						vim.cmd([[EslintFixAll]])
					end, { desc = "Eslint Fix All" })
				end,
				-- on_attach = function()
				-- 	vim.api.nvim_create_autocmd("BufWritePre", {
				-- 		pattern = "*.tsx,*.ts,*.jsx,*.js",
				-- 		callback = function()
				-- 			vim.cmd([[EslintFixAll]])
				-- 		end,
				-- 	})
				-- end,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"require",
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
				},
			})
		end,
	},
}
