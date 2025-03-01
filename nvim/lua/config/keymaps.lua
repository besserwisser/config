-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "gQ", "<Nop>", { noremap = true })
vim.keymap.set("n", "q:", "<Nop>", { noremap = true })

vim.keymap.set("n", "<leader>e", "<Cmd>Explore<CR>", { desc = "Explore current files's directory" })
vim.keymap.set("n", "<leader>E", "<Cmd>Explore .<CR>", { desc = "Explore current working directory" })
