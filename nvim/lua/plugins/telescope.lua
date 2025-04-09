return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-lua/plenary.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
  config = function()
    local telescope = require("telescope")

    -- first setup telescope
    telescope.setup({
      extensions = {
        file_browser = {
          respect_gitignore = false,
          hidden = {
            file_browser = true,
            folder_browser = true,
          },
        },
      },
    })

    -- then load the extension
    telescope.load_extension("live_grep_args")
    telescope.load_extension("file_browser")
  end,
  keys = {
    -- Otherwise we cannot remap
    { "<leader>/", vim.NIL },
    { "<leader><space>", vim.NIL },
  },
}
