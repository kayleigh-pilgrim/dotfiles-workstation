-- Floating terminal.
return {
  'voldikss/vim-floaterm',

  cmd = {
    'FloatermNew',
    'FloatermToggle',
    'FloatermPrev',
    'FloatermNext',
    'FloatermFirst',
    'FloatermLast',
    'FloatermShow',
    'FloatermHide',
    'FloatermKill',
    'FloatermUpdate',
    'FloatermSend',
  },

  keys = {
    {
      '<F1>',
      '<cmd>FloatermToggle<CR>',
      mode = 'n',
      silent = true,
      desc = 'Toggle floating terminal',
    },
    {
      '<F1>',
      '<Esc><cmd>FloatermToggle<CR>',
      mode = 'i',
      silent = true,
      desc = 'Toggle floating terminal',
    },
    {
      '<F1>',
      [[<C-\><C-n><cmd>FloatermToggle<CR>]],
      mode = 't',
      silent = true,
      desc = 'Toggle floating terminal',
    },
  },

  init = function()
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_position = 'center'
  end,
}
