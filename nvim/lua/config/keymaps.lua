-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- best keymap in the world
vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>", { desc = "Ex" })

-- close quickfix window
vim.keymap.set("n", "<leader>q", "<cmd>cclose<CR>", { desc = "cclose" })

-- show line diagnostics in floating window, e.g. errors, warnings, etc.
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "vim.diagnostic.open_float" })
-- show diagnostics in quickfix window
vim.keymap.set("n", "<leader>D", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "vim.diagnostic.setqflist({ open = true })" })
