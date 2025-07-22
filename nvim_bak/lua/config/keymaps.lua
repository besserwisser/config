-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "gQ", "<Nop>", { noremap = true })
vim.keymap.set("n", "q:", "<Nop>", { noremap = true })

vim.keymap.set("n", "<leader>am", "<Cmd>CopilotChatModels<CR>", { desc = "Open Copilot Chat Models" })

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

-- Asked gemini to rewrite this in lua and only for ]l and [l https://vim.fandom.com/wiki/Move_to_next/previous_line_with_same_indentation
-- Function to jump to the next/previous line with the same indentation level,
-- skipping blank lines.
--
-- Args:
--   is_forward (boolean): true to search forward (like ]l), false to search backward (like [l]).
local function jump_to_same_indent_level(is_forward)
  local current_winnr = 0 -- 0 for current window
  local current_bufnr = 0 -- 0 for current buffer

  local cursor_pos = vim.api.nvim_win_get_cursor(current_winnr)
  local current_line_num = cursor_pos[1] -- 1-based line number
  local original_col_1_idx = vim.fn.col(".") -- Get 1-based visual column for restoration

  local last_line_num = vim.api.nvim_buf_line_count(current_bufnr)
  local current_indent = vim.fn.indent(current_line_num)

  local step_value
  if is_forward then
    step_value = 1
  else
    step_value = -1
  end

  local target_line_num = current_line_num

  while true do
    target_line_num = target_line_num + step_value

    -- Check if we've gone past the beginning or end of the file
    if target_line_num <= 0 or target_line_num > last_line_num then
      vim.notify("No further line with same indent found", vim.log.levels.WARN)
      return
    end

    local target_indent = vim.fn.indent(target_line_num)

    -- Condition 1: Indentation must be the same as the current line's indent
    if target_indent == current_indent then
      local line_content = vim.fn.getline(target_line_num)

      -- Condition 2: Line must not be "blank" (must contain at least one non-whitespace character)
      -- :match("%S") returns the first non-whitespace character if found, otherwise nil.
      if line_content:match("%S") and not line_content:match("^%s*[%]}%),]+%s*$") then
        -- Found a suitable line
        -- Move cursor to the target line, column 0 (0-indexed for the API)
        vim.api.nvim_win_set_cursor(current_winnr, { target_line_num, 0 })
        -- Attempt to restore the original column using normal mode `N|` (1-based column)
        vim.cmd("normal! " .. original_col_1_idx .. "|")
        return
      end
    end
  end
end

-- Normal mode mappings
-- For "]l": Go to next line with same indentation level (skipping blanks)
vim.keymap.set("n", "]l", function()
  jump_to_same_indent_level(true)
end, { noremap = true, silent = true, desc = "Next line with same indent" })

-- For "[l": Go to previous line with same indentation level (skipping blanks)
vim.keymap.set("n", "[l", function()
  jump_to_same_indent_level(false)
end, { noremap = true, silent = true, desc = "Previous line with same indent" })

vim.keymap.set("n", "<leader>gf", ":Telescope git_file_history<CR>", { desc = "Show file history" })
vim.keymap.set("n", "<leader>gF", ":Telescope git_bcommits<CR>", { desc = "Show file history (diffs)" })
