vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
})

local mason = require("mason")
mason.setup()

-- based on https://www.reddit.com/r/neovim/comments/1p50srp/comment/nqgc8i8/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
local mr = require("mason-registry")
mr.refresh(function(success, err)
	if not success then
		vim.notify("Mason registry refresh failed: " .. tostring(err), vim.log.levels.WARN)
		return
	end
	for _, tool in ipairs({
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"js-debug-adapter",
		"prettierd",
		"stylua",
		"tree-sitter-cli",
		"vue-language-server",
		"copilot-language-server",
		"terraform-ls",
	}) do
		local ok, p = pcall(mr.get_package, tool)
		if ok then
			local is_globally_installed = vim.fn.executable(tool) == 1
			if not is_globally_installed and not p:is_installed() then
				p:install()
			end
		end
	end
end)
