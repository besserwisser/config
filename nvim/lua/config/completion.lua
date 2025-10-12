local utils = require("config.utils")

vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.o.complete = "o"

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableNativeCompletion", { clear = true }),
	desc = "Enable vim.lsp.completion and documentation",
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			-- Enable native LSP completion. Thanks to vim.bo.autocomplete, we don't need autotrigger, but I want to use the convert function for styling.
			vim.lsp.completion.enable(true, client.id, args.buf, {
				convert = function(item)
					return {
						-- remove parentheses from function/method completion items
						abbr = item.label:gsub("%b()", ""),
						-- Enable colors for kinds, e.g. Function, Variable, etc.
						kind_hlgroup = "LspKind" .. (vim.lsp.protocol.CompletionItemKind[item.kind] or ""),
					}
				end,
			})

			-- only enable autocomplete in normal buffers
			vim.bo.autocomplete = vim.bo.buftype == ""

			-- enable documentation on completion item selection
			local augroup = vim.api.nvim_create_augroup("CompletionDocumentation" .. client.id, { clear = true })
			utils.enable_completion_documentation(client, augroup, args.buf)
		end
	end,
})
