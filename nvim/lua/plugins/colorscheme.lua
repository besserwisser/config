vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })

require("kanagawa").setup({
	transparent = true,
	colors = {
		palette = {
			-- background of line number column
			sumiInk4 = "#171717",
			-- background of cursor line
			sumiInk5 = "#252525",
		},
	},
})

vim.cmd([[colorscheme kanagawa]])

-- Unified transparent highlight groups
local transparent_groups = {
	"StatusLine", -- Active status line
	"StatusLineNC", -- Inactive status line
	"Pmenu", -- Popup menu
	"PmenuSbar", -- Popup menu scrollbar
	"NormalFloat", -- Floating windows
	"FloatBorder", -- Floating window borders
}

for _, group in ipairs(transparent_groups) do
	vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
end
