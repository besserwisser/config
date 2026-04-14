vim.pack.add({
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/windwp/nvim-autopairs",
})

local utils = require("config.utils")

require("nvim-ts-autotag").setup({})
require("nvim-autopairs").setup({ check_ts = true, map_cr = false })

-- The default autopairs completion_confirm() bypasses autopairs_cr() whenever
-- pumvisible() != 0, even if nothing is selected ("noselect" completeopt).
-- Override to only skip autopairs when an item is actually selected.
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "selected" }).selected ~= -1 then
		return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
	end
	return require("nvim-autopairs").autopairs_cr()
end, { expr = true, replace_keycodes = false })

vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.o.complete = "o"
vim.o.pumheight = 15

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableNativeCompletion", { clear = true }),
	desc = "Enable vim.lsp.completion and documentation",
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			-- Enable native LSP completion.
			vim.lsp.completion.enable(true, client.id, args.buf, {
				convert = function(item)
					return {
						-- remove parentheses from function/method completion items
						abbr = item.label:gsub("%b()", ""),
						-- Enable colors for kinds, e.g. Function, Variable, etc.
						kind_hlgroup = "LspKind" .. (vim.lsp.protocol.CompletionItemKind[item.kind] or ""),
						-- Show the source module/package (e.g. "react", "lodash") for auto-imports
						menu = item.labelDetails and item.labelDetails.description or "",
					}
				end,
			})

			vim.bo.autocomplete = vim.bo.buftype == ""
		end
	end,
})

local function set_popup_border(winid)
	if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
		pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
	end
end

-- Case 1: item already has `info` — popup is created by C code before CompleteChanged
-- Lua callbacks fire; grab preview_winid after yielding to the event loop.
vim.api.nvim_create_autocmd("CompleteChanged", {
	group = vim.api.nvim_create_augroup("CompletionPopupBorder", { clear = true }),
	callback = function()
		vim.schedule(function()
			local info = vim.fn.complete_info({ "selected" })
			set_popup_border(info.preview_winid)
		end)
	end,
})

-- Case 2: async LSP completionItem/resolve — popup is created via nvim__complete_set
-- after a network round-trip, long after CompleteChanged has already fired.
if vim.api.nvim__complete_set then
	local orig = vim.api.nvim__complete_set
	---@diagnostic disable-next-line: duplicate-set-field
	vim.api.nvim__complete_set = function(index, opts)
		local windata = orig(index, opts)
		set_popup_border(windata and windata.winid)
		return windata
	end
end
