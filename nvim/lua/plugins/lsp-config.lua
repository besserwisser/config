return {
  {
    "williamboman/mason.nvim",
    lazy = false,
		opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
			ensure_installed = {
				"lua_ls", "ts_ls"
			}
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
				settings = {
				Lua = {
					diagnostics = {
						-- Prevet errors of global vim object usage in config
						globals = { 'vim' },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
					}
				}
			}
			})
			lspconfig.ts_ls.setup({})
    end,
  },
}
