local icons = LazyVim.config.icons

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", separator = "", padding = { left = 1, right = 0 } },
      },
      lualine_y = { {
        "filename",
        path = 1,
        newfile_status = true,
      } },
    },
  },
}
