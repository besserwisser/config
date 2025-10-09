-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Alternative to <C-w>d
vim.keymap.set("n", "<leader>D", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "Show diagnostics in quickfix window" })

-- disable arrow keys in all modes
vim.keymap.set({ "n", "i", "v", "c" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Down>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Right>", "<Nop>")
