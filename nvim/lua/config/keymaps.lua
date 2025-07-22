-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- best keymap in the world
vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>", { desc = "Open file explorer" })
