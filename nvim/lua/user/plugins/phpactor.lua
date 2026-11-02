-- PHP refactoring commands without starting a second PHP LSP.
return {
  'gbprod/phpactor.nvim',

  ft = {
    'php',
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  keys = {
    {
      '<leader>pm',
      '<cmd>PhpActor context_menu<CR>',
      desc = 'Phpactor context menu',
    },
    {
      '<leader>pn',
      '<cmd>PhpActor new_class<CR>',
      desc = 'Create PHP class',
    },
  },

  opts = {
    install = {
      check_on_startup = 'daily',
    },

    -- Intelephense is already configured as the PHP language server.
    -- Do not start Phpactor as a second LSP client.
    lspconfig = {
      enabled = false,
    },
  },
}
