-- Display available key mappings while a key sequence is pending.
return {
  'folke/which-key.nvim',

  event = 'VeryLazy',

  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({
          global = false,
        })
      end,
      desc = 'Buffer-local keymaps',
    },
  },

  opts = {
    preset = 'modern',

    delay = function(context)
      -- Plugin-provided key groups can appear immediately, while
      -- ordinary key sequences wait briefly to avoid visual noise.
      return context.plugin and 0 or 300
    end,

    spec = {
      {
        '<leader>p',
        group = 'PHP',
      },
      {
        '<leader>t',
        group = 'Tests',
      },
    },

    win = {
      border = 'rounded',
      padding = {
        1,
        2,
      },
    },

    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
    },

    plugins = {
      marks = true,
      registers = true,

      spelling = {
        enabled = true,
        suggestions = 20,
      },

      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
  },
}
