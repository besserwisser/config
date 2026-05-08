-- Core editor state first: options set leader and disable netrw before plugins use them.
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- Load the theme early so later plugin setup uses the final highlight groups.
require("plugins.colorscheme")

-- Add plugin runtimepaths before EmmyLua snapshots `runtimepath` for hover/docs.
require("plugins.lsp-config")
require("plugins.binaries")
require("plugins.syntax-parser")
require("plugins.explorer")
require("plugins.fuzzy-find")
require("plugins.formatting")
require("plugins.preview")
require("plugins.debugging")
require("plugins.keymap-helper")

-- Register LSP consumers before enabling servers so attach hooks always exist.
require("config.completion")
require("plugins.ai")

-- Enable LSP after plugin runtimepaths are final so EmmyLua indexes plugin Lua code.
require("config.lsp")

-- Use cfilter with the command :Cfilter to filter the quickfix list. For example `:Cfilter error` will show only the errors in the quickfix list, while `:Cfilter! error` will show anything but the errors.
vim.cmd("packadd cfilter")
-- Use undotree with the command :Undotree to visualize the undo history. This is useful for understanding the changes made to a file and for easily reverting to previous states.
vim.cmd("packadd nvim.undotree")
-- Use `git difftool -d main` to compare the current branch with the main branch. This is useful for reviewing changes before committing or for understanding the differences between branches.
vim.cmd("packadd nvim.difftool")
