vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
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
local has_textobjects, textobjects = pcall(require, "nvim-treesitter-textobjects")
if has_textobjects then
	textobjects.setup({
		select = {
			lookahead = true,
			include_surrounding_whitespace = true,
			selection_modes = {
				["@function.outer"] = "V",
				["@class.outer"] = "V",
			},
		},
		move = {
			set_jumps = true,
		},
	})

	local select = require("nvim-treesitter-textobjects.select")
	local move = require("nvim-treesitter-textobjects.move")
	local swap = require("nvim-treesitter-textobjects.swap")

	local function select_textobject(query)
		return function()
			select.select_textobject(query, "textobjects")
		end
	end

	local function move_textobject(method, query)
		return function()
			move[method](query, "textobjects")
		end
	end

	local function swap_textobject(method, query)
		return function()
			swap[method](query, "textobjects")
		end
	end

	local select_keymaps = {
		["af"] = { "@function.outer", "Around function" },
		["if"] = { "@function.inner", "Inside function" },
		["ac"] = { "@class.outer", "Around class" },
		["ic"] = { "@class.inner", "Inside class" },
		["aa"] = { "@parameter.outer", "Around parameter" },
		["ia"] = { "@parameter.inner", "Inside parameter" },
		["a,"] = { "@parameter.outer", "Around parameter" },
		["i,"] = { "@parameter.inner", "Inside parameter" },
		["a."] = { "@call.outer", "Around call" },
		["i."] = { "@call.inner", "Inside call" },
	}

	for lhs, mapping in pairs(select_keymaps) do
		vim.keymap.set({ "x", "o" }, lhs, select_textobject(mapping[1]), { desc = mapping[2] })
	end

	local move_keymaps = {
		["]m"] = { "goto_next_start", "@function.outer", "Next function start" },
		["]M"] = { "goto_next_end", "@function.outer", "Next function end" },
		["[m"] = { "goto_previous_start", "@function.outer", "Previous function start" },
		["[M"] = { "goto_previous_end", "@function.outer", "Previous function end" },
		["]]"] = { "goto_next_start", "@class.outer", "Next class start" },
		["]["] = { "goto_next_end", "@class.outer", "Next class end" },
		["[["] = { "goto_previous_start", "@class.outer", "Previous class start" },
		["[]"] = { "goto_previous_end", "@class.outer", "Previous class end" },
		["]f"] = { "goto_next_start", "@call.outer", "Next call start" },
		["[f"] = { "goto_previous_start", "@call.outer", "Previous call start" },
		["]a"] = { "goto_next_start", "@parameter.outer", "Next parameter start" },
		["[a"] = { "goto_previous_start", "@parameter.outer", "Previous parameter start" },
	}

	for lhs, mapping in pairs(move_keymaps) do
		vim.keymap.set({ "n", "x", "o" }, lhs, move_textobject(mapping[1], mapping[2]), { desc = mapping[3] })
	end

	vim.keymap.set("n", "<leader>a", swap_textobject("swap_next", "@parameter.inner"), { desc = "Swap next parameter" })
	vim.keymap.set("n", "<leader>A", swap_textobject("swap_previous", "@parameter.inner"), { desc = "Swap previous parameter" })
end

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
