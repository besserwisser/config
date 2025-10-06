vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local nvim_treesitter_configs = require("nvim-treesitter.configs")

nvim_treesitter_configs.setup({
	ensure_installed = {
		"lua",
		"javascript",
		"typescript",
		"tsx",
		"json",
		"css",
		"html",
		"http",
		"diff",
		"vue",
		"regex",
		"terraform",
	},
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
	modules = {},
	sync_install = false,
	ignore_install = {},
})

-- run :TSUpdate when plugin is updated
vim.api.nvim_create_autocmd({ "PackChanged" }, {
	group = vim.api.nvim_create_augroup("TreesitterUpdated", { clear = true }),
	callback = function(args)
		local spec = args.data.spec
		if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
			vim.notify("nvim-treesitter was updated, running :TSUpdate", vim.log.levels.INFO)
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end
	end,
})

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
