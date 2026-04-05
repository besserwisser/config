-- This file can be delteted, as soon as this is merged: https://github.com/neovim/nvim-lspconfig/pull/4376

local util = require("lspconfig.util")

---@type vim.lsp.Config
return {
	before_init = function(_, config)
		config.settings = vim.tbl_deep_extend("keep", config.settings, {
			editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
		})
	end,
}
