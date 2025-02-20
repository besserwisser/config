return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><space>", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
  },
}
