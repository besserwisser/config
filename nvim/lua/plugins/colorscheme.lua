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

vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3a3a4a", fg = "NONE" })
vim.api.nvim_set_hl(0, "PmenuKind", { bg = "NONE", fg = "#9ca3af" })
vim.api.nvim_set_hl(0, "PmenuKindSel", { bg = "#3a3a4a", fg = "#9ca3af" })
vim.api.nvim_set_hl(0, "PmenuExtra", { bg = "NONE", fg = "#6b7280" })
vim.api.nvim_set_hl(0, "PmenuExtraSel", { bg = "#3a3a4a", fg = "#6b7280" })
