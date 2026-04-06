vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })

require("kanagawa").setup({
	transparent = true,
	colors = {
		palette = {
			-- background of cursor line
			sumiInk5 = "#252525",
		},
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		local theme = colors.theme
		local makeDiagnosticColor = function(color)
			local c = require("kanagawa.lib.color")
			return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
		end

		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },

			-- Save an hlgroup with dark background and dimmed foreground
			-- so that you can use it where your still want darker windows.
			-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
			NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

			-- Popular plugins that open floats will link to NormalFloat by default;
			-- set their background accordingly if you wish to keep them dark and borderless
			LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

			-- Transparent completion (popup) menu
			Pmenu = { fg = theme.ui.shade0, bg = "none" },
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuKind = { fg = theme.ui.special, bg = "none" },
			PmenuKindSel = { fg = theme.ui.special, bg = theme.ui.bg_p2 },
			PmenuExtra = { fg = theme.ui.fg_dim, bg = "none" },
			PmenuExtraSel = { fg = theme.ui.fg_dim, bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = "none" },
			PmenuThumb = { bg = theme.ui.bg_p2 },

			-- Blend colors against the "active" background
			DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
			DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
			DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
			DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

			-- Transparent status line background
			StatusLine = { bg = "none" },
			StatusLineNC = { bg = "none" },

			-- Match snacks picker cursor line to regular CursorLine
			SnacksPickerCursorLine = { link = "CursorLine" },
			SnacksPickerListCursorLine = { link = "CursorLine" },
		}
	end,
})

require("kanagawa").load("wave")
