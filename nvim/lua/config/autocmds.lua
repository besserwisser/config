-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  pattern = ".env*",
  callback = function(e)
    -- Disable diagnostics for .env files
    vim.diagnostic.enable(false, { bufnr = e.buf })
    -- Disable autoformatting for .env files
    vim.b.autoformat = false
  end,
})

local augroup_format_on_save = vim.api.nvim_create_augroup("MyLspActionsOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup_format_on_save,
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  -- Ensure the Lua code string correctly calls the function
  callback = function()
    if
      LazyVim
      and LazyVim.lsp
      and LazyVim.lsp.action
      and LazyVim.lsp.action["source.removeUnused.ts"]
      and type(LazyVim.lsp.action["source.removeUnused.ts"]) == "function"
    then
      pcall(LazyVim.lsp.action["source.removeUnused.ts"])
    end
  end,

  desc = "Remove unused imports on save (for TS/JS) via command",
})
