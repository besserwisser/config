return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      eslint = {
        settings = {
          rulesCustomizations = {
            -- https://github.com/import-js/eslint-plugin-import/issues/1913
            { rule = "import/no-extraneous-dependencies", severity = "off" },
          },
        },
      },
    },
  },
}
