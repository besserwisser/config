return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- ...elided others
      "graphql-language-service-cli", -- required for graphql-lsp
    },
  },
}
