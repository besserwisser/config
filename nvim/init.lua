require("config.options")
require("config.autocmds")
require("config.keymaps")

require("plugins.colorscheme")
require("plugins.explorer")
require("plugins.syntax-parser")
require("plugins.lsp-config")
require("plugins.binaries")

-- It seems like this now needs to be after lsp-config and binaries
require("config.lsp")
require("config.completion")

require("plugins.fuzzy-find")
require("plugins.formatting")
require("plugins.debugging")
require("plugins.ai")
require("plugins.preview")
require("plugins.keymap-helper")

-- Use cfilter with the command :Cfilter to filter the quickfix list. For example `:Cfilter error` will show only the errors in the quickfix list, while `:Cfilter! error` will show anything but the errors.
vim.cmd("packadd cfilter")
-- Use undotree with the command :Undotree to visualize the undo history. This is useful for understanding the changes made to a file and for easily reverting to previous states.
vim.cmd("packadd nvim.undotree")
-- Use `git difftool -d main` to compare the current branch with the main branch. This is useful for reviewing changes before committing or for understanding the differences between branches.
vim.cmd("packadd nvim.difftool")
