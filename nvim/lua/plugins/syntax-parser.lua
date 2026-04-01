vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local function setup_treesitter()
	require("nvim-treesitter.configs").setup({
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
			"bash",
		},
		install_dir = vim.fn.stdpath("data") .. "/site",
		auto_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		modules = {},
		sync_install = false,
		ignore_install = {},
	})
end

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
