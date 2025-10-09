-- disable mouse support
vim.o.mouse = ""

-- disable startup screen
vim.o.shortmess = vim.o.shortmess .. "I"
vim.notify(vim.o.shortmess)

-- Enable the new Lua loader
vim.loader.enable()

-- Neovim options configuration file
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- set cmd line to zero to hide it while not using it
vim.o.cmdheight = 0

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- make tabs look like two characters
vim.opt.tabstop = 2
-- make >> and << 2 characters
vim.opt.shiftwidth = 2

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 500

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Save undo history
vim.o.undofile = true

-- round the corners of floating windows
vim.o.winborder = "rounded"

-- space when scrolling down or up
vim.o.scrolloff = 10

-- Disable swap files
vim.o.swapfile = false

-- avoid ugly wrapping of long lines
vim.o.wrap = false

-- Function to show search count in statusline
_G.search_count = function()
	local result = vim.fn.searchcount({ recompute = 1 })
	if vim.tbl_isempty(result) then
		return ""
	end

	-- Check if we're currently in search mode or if search highlighting is active
	local search_active = vim.v.hlsearch == 1 and vim.fn.getreg("/") ~= ""

	-- Return empty if search is not active (e.g., after ESC or :noh)
	if not search_active then
		return ""
	end

	if result.incomplete == 1 then -- timed out
		return " [?/??]"
	elseif result.incomplete == 2 then -- max count exceeded
		if result.total > result.maxcount and result.current > result.maxcount then
			return string.format(" [>%d/>%d]", result.current, result.total)
		elseif result.total > result.maxcount then
			return string.format(" [%d/>%d]", result.current, result.total)
		end
	end

	return string.format(" [%d/%d]", result.current, result.total)
end

-- Simplify the status line and add search count
vim.o.statusline = "%{reg_recording()} %= %F %m%{v:lua.search_count()}"

-- Enable cursorline
vim.o.cursorline = true

-- ui improvements https://www.reddit.com/r/neovim/comments/1kcz8un/great_improvements_to_the_cmdline_in_nightly/
require("vim._extui").enable({
	msg = {
		target = "msg",
		timeout = 6000,
	},
})

-- Folding settings, toggle with za or zR/zM. See :help fold-commands.
vim.o.foldmethod = "expr" -- Use expression for folding
vim.o.foldlevel = 99 -- Start with all folds open

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = true,
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("VisualEffectYank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
	end,
})
