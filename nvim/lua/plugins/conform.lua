return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      xml = { "xmllint" },
      sh = function(buffnr)
        local path = vim.api.nvim_buf_get_name(buffnr)
        local filename = vim.fn.fnamemodify(path, ":t")
        -- Prevent shfmt from formatting .env files
        if filename:match("%.env$") then
          return {}
        end
        return { "shfmt" }
      end,
    },
  },
}
