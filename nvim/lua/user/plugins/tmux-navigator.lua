-- Navigate seamlessly between Neovim windows and tmux panes.
return {
  'christoomey/vim-tmux-navigator',

  -- Load shortly after startup so the plugin can install its
  -- terminal-mode mappings before a terminal is opened.
  event = 'VeryLazy',

  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },

  keys = {
    {
      '<C-h>',
      '<cmd>TmuxNavigateLeft<CR>',
      desc = 'Navigate left',
    },
    {
      '<C-j>',
      '<cmd>TmuxNavigateDown<CR>',
      desc = 'Navigate down',
    },
    {
      '<C-k>',
      '<cmd>TmuxNavigateUp<CR>',
      desc = 'Navigate up',
    },
    {
      '<C-l>',
      '<cmd>TmuxNavigateRight<CR>',
      desc = 'Navigate right',
    },
    {
      '<C-\\>',
      '<cmd>TmuxNavigatePrevious<CR>',
      desc = 'Navigate to previous pane',
    },
  },
}
