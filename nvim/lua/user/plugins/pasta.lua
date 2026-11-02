-- Adjust indentation automatically when pasting.
return {
  'ku1ik/vim-pasta',

  init = function()
    vim.g.pasta_disabled_filetypes = {
      'coffee',
      'fugitive',
      'markdown',
      'python',
      'slim',
      'yaml',
    }
  end,
}
