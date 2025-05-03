-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "gQ", "<Nop>", { noremap = true })
vim.keymap.set("n", "q:", "<Nop>", { noremap = true })

vim.keymap.set("n", "<leader>am", "<Cmd>CopilotChatModels<CR>", { desc = "Open Copilot Chat Models" })

-- https://www.reddit.com/r/neovim/comments/14e59ub/i_wrote_a_function_that_moves_the_cursor_to_the/
-- local ex_to_current_file = function()
--   local cur_file = vim.fn.expand("%:t")
--   vim.cmd.Ex()
--
--   local starting_line = 0 -- line number of the first file
--   local lines = vim.api.nvim_buf_get_lines(0, starting_line, -1, false)
--   for i, file in ipairs(lines) do
--     if file == cur_file then
--       vim.api.nvim_win_set_cursor(0, { starting_line + i, 0 })
--       return
--     end
--   end
-- end

-- vim.keymap.set("n", "<leader>e", ex_to_current_file, { desc = "Explore current files's directory" })
-- vim.keymap.set("n", "<leader>E", "<Cmd>Explore .<CR>", { desc = "Explore current working directory" })

vim.keymap.set(
  "n",
  "<leader>/",
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "Live Grep with Args" }
)

vim.keymap.set("n", "<leader>fo", "<Cmd>Rfinder<CR>", { desc = "Open file in Mac Finder" })

vim.keymap.set(
  "n",
  "<leader>e",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { desc = "Telescope file browser (curent file)" }
)
vim.keymap.set("n", "<leader>E", ":Telescope file_browser<CR>", { desc = "Telescope file browser (root)" })

vim.keymap.set("n", "<leader>fC", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy current relative file path to clipboard" })
