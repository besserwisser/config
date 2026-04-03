vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Maps parser names to the Neovim filetypes they should activate for.
-- Parsers without a standalone filetype (e.g. regex, used via injection) are omitted from the ft list.
local parser_ft_map = {
	lua = { "lua" },
	javascript = { "javascript" },
	typescript = { "typescript" },
	tsx = { "typescriptreact" },
	json = { "json" },
	css = { "css" },
	html = { "html" },
	http = { "http" },
	diff = { "diff" },
	vue = { "vue" },
	regex = {},
	terraform = { "terraform" },
	bash = { "bash", "sh" },
}

require("nvim-treesitter").install(vim.tbl_keys(parser_ft_map))

local filetypes = vim.iter(vim.tbl_values(parser_ft_map)):flatten():totable()

-- Enable treesitter highlighting, indentation, and folding per filetype
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
	pattern = filetypes,
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
	end,
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
