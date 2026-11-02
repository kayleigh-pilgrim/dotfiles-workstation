-- Split and join syntax-aware code structures.
return {
  'Wansmer/treesj',

  cmd = {
    'TSJToggle',
    'TSJSplit',
    'TSJJoin',
  },

  keys = {
    {
      '<leader>j',
      '<cmd>TSJToggle<CR>',
      desc = 'Toggle split or join',
    },
    {
      '<leader>J',
      function()
        require('treesj').toggle({
          split = {
            recursive = true,
          },
        })
      end,
      desc = 'Toggle split or join recursively',
    },
  },

  opts = {
    use_default_keymaps = false,
    check_syntax_error = true,
    max_join_length = 120,
    cursor_behavior = 'hold',
    notify = true,
    dot_repeat = true,
  },
}
