vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
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
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
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

-- Notify when an LSP client attaches
-- Track which clients have notified "ready" to avoid duplicates
local notified_clients = {}
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(args)
		local client_id = args.data.client_id
		local value = args.data.params.value
		if value.kind == "end" and not notified_clients[client_id] then
			notified_clients[client_id] = true
			local client = vim.lsp.get_client_by_id(client_id)
			if client then
				vim.notify(client.name .. " ready", vim.log.levels.INFO)
			end
		end
	end,
})
