-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Alternative to <C-w>d
vim.keymap.set("n", "<leader>D", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "Show diagnostics in quickfix window" })

-- Paste without overwriting the default register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- disable arrow keys in all modes
vim.keymap.set({ "n", "i", "v", "c" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Down>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Right>", "<Nop>")

-- Command line mode navigation (bash-like)
vim.keymap.set("c", "<C-A>", "<Home>")
vim.keymap.set("c", "<C-F>", "<Right>")
vim.keymap.set("c", "<C-B>", "<Left>")
vim.keymap.set("c", "<Esc>b", "<S-Left>")
vim.keymap.set("c", "<Esc>f", "<S-Right>")
