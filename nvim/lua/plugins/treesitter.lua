return   {
	"nvim-treesitter/nvim-treesitter", 
	branch = 'master', 
	lazy = false, 
	build = ":TSUpdate",
	opts = {
		ensure_installed = {"lua", "javascript", "typescript", "tsx", "json", "css", "html"},
		auto_install = false,
		highlight = { enable = true },
		indent = { enable = true },
	},
 }

