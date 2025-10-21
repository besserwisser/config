-- Clear highlights on search when pressing Esc in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- disable arrow keys in all modes
vim.keymap.set({ "n", "i", "v", "c" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Down>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "i", "v", "c" }, "<Right>", "<Nop>")
