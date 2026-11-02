-- Display indentation guides and the current code scope.
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',

  event = {
    'BufReadPost',
    'BufNewFile',
  },

  opts = {
    scope = {
      show_start = false,
      show_end = false,
    },

    exclude = {
      filetypes = {
        'dashboard',
        'lazy',
        'neo-tree',
      },
    },
  },
}
