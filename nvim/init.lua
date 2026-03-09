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

vim.cmd("packadd cfilter")
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")
