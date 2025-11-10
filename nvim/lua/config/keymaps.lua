-- Clear highlights on search when pressing Esc in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Update all plugins and packages
vim.keymap.set("n", "<leader>u", function()
	vim.pack.update()
	vim.cmd("TSUpdate")
	vim.cmd("MasonToolsUpdate")
end, { desc = "Update Plugins, Treesitter and Mason Tools" })
