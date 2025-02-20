-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Alternative to <C-w>d
vim.keymap.set("n", "<leader>D", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "Show diagnostics in quickfix window" })

-- Paste without overwriting the default register
vim.keymap.set("x", "<leader>p", [["_dP]])
