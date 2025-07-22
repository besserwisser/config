return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    { 'nvim-tree/nvim-web-devicons' },
  },
	keys = {
    {
      '<leader>ff',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>fg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = 'Live Grep',
    },
    {
      '<leader>fb',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find Buffers',
    },
    {
      '<leader>fh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Help Tags',
    },
    {
      '<leader>fr',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = 'Recent Files',
    },
  },
  config = function()
    require("telescope").load_extension("fzf")
  end,
}
