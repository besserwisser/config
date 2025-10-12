vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.o.complete = "o"

-- based on https://github.com/konradmalik/neovim-flake/blob/6dba374af89a294c976d72615cca6cfca583a9f2/config/native/lua/pde/lsp/completion.lua
local docs_debounce_ms = 100
local timer = vim.uv.new_timer()

---@param client vim.lsp.Client
---@param augroup integer
---@param bufnr integer
local function enable_completion_documentation(client, augroup, bufnr)
	if not timer then
		vim.notify("cannot create timer", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_create_autocmd("CompleteChanged", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			timer:stop()

			local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
			if not completion_item then
				vim.notify("no completion item", vim.log.levels.WARN)
				return
			end

			local complete_info = vim.fn.complete_info({ "selected" })
			if vim.tbl_isempty(complete_info) then
				vim.notify("no complete info", vim.log.levels.WARN)
				return
			end

			timer:start(
				docs_debounce_ms,
				0,
				vim.schedule_wrap(function()
					client:request(
						vim.lsp.protocol.Methods.completionItem_resolve,
						completion_item,
						function(err, result)
							if err ~= nil then
								vim.notify("client " .. client.id .. vim.inspect(err), vim.log.levels.ERROR)
								return
							end

							local docs = vim.tbl_get(result, "documentation", "value")
							if not docs then
								vim.notify("no documentation", vim.log.levels.INFO)
								return
							end

							local wininfo = vim.api.nvim__complete_set(complete_info.selected, { info = docs })
							-- sometimes wininfo is empty, e.g. when the completion menu is closed before the docs arrivej	jj
							if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
								vim.notify("no valid wininfo", vim.log.levels.WARN)
								return
							end

							vim.api.nvim_win_set_config(wininfo.winid, { border = "rounded" })
							vim.wo[wininfo.winid].conceallevel = 2
							vim.wo[wininfo.winid].concealcursor = "niv"

							if not vim.api.nvim_buf_is_valid(wininfo.bufnr) then
								return
							end

							vim.bo[wininfo.bufnr].syntax = "markdown"
							vim.treesitter.start(wininfo.bufnr, "markdown")
						end,
						bufnr
					)
				end)
			)
		end,
	})
end

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

			vim.bo.autocomplete = vim.bo.buftype == ""

			-- enable documentation on completion item selection
			local augroup = vim.api.nvim_create_augroup("CompletionDocumentation" .. client.id, { clear = true })
			enable_completion_documentation(client, augroup, args.buf)
		end
	end,
})
