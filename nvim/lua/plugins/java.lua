return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          jdtls = {
            -- Your custom jdtls settings goes here
            settings = {
              java = {
                configuration = {
                  runtimes = {
                    {
                      name = "JavaSE-21",
                      path = "/Library/Java/JavaVirtualMachines/temurin-21.jdk/",
                      default = true,
                    },
                  },
                },
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              -- Your custom nvim-java configuration goes here
            })
          end,
        },
      },
    },
  },
}
