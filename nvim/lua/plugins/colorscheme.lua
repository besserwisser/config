return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		}
	},
	config = function(_, opts)
		require("tokyonight").setup(opts);
		-- load the colorscheme here
		vim.cmd[[colorscheme tokyonight-moon]];
	end,
}
