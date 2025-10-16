vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

local tokyonight = require("tokyonight")

tokyonight.setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})

vim.cmd([[colorscheme tokyonight-storm]])

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
