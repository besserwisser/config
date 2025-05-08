return {
  "williamboman/mason.nvim",
  version = "^1.0.0",
  opts = {
    ensure_installed = {
      -- ...elided others
      "graphql-language-service-cli", -- required for graphql-lsp
    },
  },
}
