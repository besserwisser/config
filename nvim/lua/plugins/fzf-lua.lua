return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (files)" },
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
  },
}
