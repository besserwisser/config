vim.lsp.config("emmylua_ls", {
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

-- Temp fix until this is merged: Update tailwindcss.lua to support multiple import patterns #4371
-- Remove the lsp/tailwindcss.lua file and this custom config once the PR is merged and released.
-- also don't forget to add the classFunctions  			classFunctions = { "cva", "cx", "cn" },
-- Use git ls-files to respect .gitignore and avoid scanning node_modules or
-- other large untracked directories. See https://github.com/neovim/nvim-lspconfig/issues/4373
vim.lsp.config("tailwindcss", dofile(vim.fn.stdpath("config") .. "/lsp/tailwindcss.lua"))
-- vscode style color preview with square icon as virtual text instead of full color background
vim.lsp.document_color.enable(true, nil, { style = "virtual" })

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
		"typescript",
		"typescriptreact",
		"vue",
	},
})

-- For now I use vtsls over tsgo, because vtsls supports Vue files. Also tsgo did not work with file completion in import/export statements.
vim.lsp.enable({
	"vtsls",
	"emmylua_ls",
	"eslint",
	"vue_ls",
	"copilot",
	"terraformls",
	"cssls",
	"html",
	"tailwindcss",
	"emmet_language_server",
})

vim.api.nvim_create_autocmd("LspProgress", {
	buffer = buf,
	callback = function(ev)
		local value = ev.data.params.value
		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. ev.data.client_id,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

vim.api.nvim_create_user_command("LspConfigOpen", function(opts)
	local path = vim.api.nvim_get_runtime_file("lsp/" .. opts.args .. ".lua", false)[1]
	if path then
		vim.cmd.edit(path)
	else
		vim.notify("Not found: " .. opts.args)
	end
end, { nargs = 1 })
