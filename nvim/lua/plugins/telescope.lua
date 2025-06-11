return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-lua/plenary.nvim",
      {
        "isak102/telescope-git-file-history.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "tpope/vim-fugitive",
        },
      },
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
  config = function()
    local telescope = require("telescope")

    local fb_actions = require("telescope._extensions.file_browser.actions")
    local actions = require("telescope.actions")

    local lga_actions = require("telescope-live-grep-args.actions")

    -- first setup telescope
    telescope.setup({
      defaults = {
        preview = {
          -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
          mime_hook = function(filepath, bufnr, opts)
            local is_image = function(filepath)
              local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
              local split_path = vim.split(filepath:lower(), ".", { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _)
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d .. "\r\n")
                end
              end
              vim.fn.jobstart({
                "catimg",
                filepath, -- Terminal image viewer command
              }, { on_stdout = send_output, stdout_buffered = true, pty = true })
            else
              require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
            end
          end,
        },
        mappings = {
          ["i"] = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
        },
      },
      extensions = {
        file_browser = {
          hidden = {
            file_browser = true,
            folder_browser = true,
          },
          mappings = {
            ["i"] = {
              ["<A-h>"] = fb_actions.toggle_respect_gitignore,
            },
            ["n"] = {
              ["h"] = fb_actions.toggle_respect_gitignore,
            },
          },
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              -- There are more options like "-i" to ignore case or "--no-ignore"
              ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --type ts" }),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- iglob with buffer folder string
              ["<C-o>"] = function(prompt_bufnr)
                local buffer_folder_path = vim.fn.expand("#")
                local first_two_segments = buffer_folder_path:match("^([^/]+/[^/]+)/")
                local first_segment = buffer_folder_path:match("^([^/]+)/")
                local iglob
                if first_two_segments then
                  iglob = " --iglob " .. first_two_segments .. "/**"
                elseif first_segment then
                  iglob = " --iglob " .. first_segment .. "/**"
                else
                  iglob = " --iglob /**"
                end
                lga_actions.quote_prompt({ postfix = iglob })(prompt_bufnr)
              end,
              -- exclude spec.ts files
              ["<C-l>"] = lga_actions.quote_prompt({ postfix = " --iglob !*.spec.ts" }),
            },
          },
        },
      },
    })

    -- then load the extension
    telescope.load_extension("live_grep_args")
    telescope.load_extension("file_browser")
    telescope.load_extension("git_file_history")
  end,
  keys = {
    -- Otherwise we cannot remap
    { "<leader>/", vim.NIL },
    { "<leader><space>", vim.NIL },
  },
}
