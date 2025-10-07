vim.pack.add({ { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("^1") } })

require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 50,
		},
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
	},
	signature = {
		enabled = true,
		window = {
			show_documentation = true,
		},
	},
})

-- vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "fuzzy", "popup" }
--
-- vim.api.nvim_create_autocmd("LspAttach", {

--	group = vim.api.nvim_create_augroup("EnableNativeCompletion", { clear = true }),
-- 	desc = "Enable vim.lsp.completion and documentation",
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if client:supports_method("textDocument/completion") then
-- 			local chars = {}
-- 			for i = 32, 126 do
-- 				table.insert(chars, string.char(i))
-- 			end
-- 			client.server_capabilities.completionProvider.triggerCharacters = chars
-- 			vim.lsp.completion.enable(true, client.id, args.buf, {
-- 				autotrigger = true,
-- 			})
-- 		end
-- 	end,
-- })
