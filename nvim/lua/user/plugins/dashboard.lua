-- Start screen.
local header = {
  '',
  '',
  ' ██ ▄█▀▄▄▄     ▓██   ██▓ ██▓    ▓█████  ██▓  ▄████  ██░ ██',
  ' ██▄█▒▒████▄    ▒██  ██▒▓██▒    ▓█   ▀ ▓██▒ ██▒ ▀█▒▓██░ ██▒',
  '▓███▄░▒██  ▀█▄   ▒██ ██░▒██░    ▒███   ▒██▒▒██░▄▄▄░▒██▀▀██░',
  '▓██ █▄░██▄▄▄▄██  ░ ▐██▓░▒██░    ▒▓█  ▄ ░██░░▓█  ██▓░▓█ ░██',
  '▒██▒ █▄▓█   ▓██▒ ░ ██▒▓░░██████▒░▒████▒░██░░▒▓███▀▒░▓█▒░██▓',
  '▒ ▒▒ ▓▒▒▒   ▓▒█░  ██▒▒▒ ░ ▒░▓  ░░░ ▒░ ░░▓   ░▒   ▒  ▒ ░░▒░▒',
  '░ ░▒ ▒░ ▒   ▒▒ ░▓██ ░▒░ ░ ░ ▒  ░ ░ ░  ░ ▒ ░  ░   ░  ▒ ░▒░ ░',
  '░ ░░ ░  ░   ▒   ▒ ▒ ░░    ░ ░      ░    ▒ ░░ ░   ░  ░  ░░ ░',
  '░  ░        ░  ░░ ░         ░  ░   ░  ░ ░        ░  ░  ░  ░',
  '                ░ ░',
  '',
  '',
}

local function set_dashboard_highlights()
  vim.api.nvim_set_hl(0, 'DashboardHeader', {
    fg = '#6272a4',
  })

  vim.api.nvim_set_hl(0, 'DashboardDesc', {
    fg = '#f8f8f2',
  })

  vim.api.nvim_set_hl(0, 'DashboardIcon', {
    fg = '#bd93f9',
  })

  vim.api.nvim_set_hl(0, 'DashboardKey', {
    fg = '#6272a4',
  })

  vim.api.nvim_set_hl(0, 'DashboardFooter', {
    fg = '#6272a4',
  })
end

return {
  'nvimdev/dashboard-nvim',

  event = 'VimEnter',

  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  opts = {
    theme = 'doom',

    config = {
      header = header,

      center = {
        {
          icon = '  ',
          desc = 'New file',
          key = 'n',
          action = 'enew',
        },
        {
          icon = '  ',
          desc = 'Find file',
          key = 'f',
          keymap = 'SPC f',
          action = 'Telescope find_files',
        },
        {
          icon = '󰋚  ',
          desc = 'Recent files',
          key = 'h',
          keymap = 'SPC h',
          action = 'Telescope oldfiles',
        },
        {
          icon = '󰊄  ',
          desc = 'Find text',
          key = 'g',
          keymap = 'SPC g',
          action = 'Telescope live_grep',
        },
        {
          icon = '󰅚  ',
          desc = 'Quit Neovim',
          key = 'q',
          action = 'qa',
        },
      },

      footer = {},
      vertical_center = true,
    },

    hide = {
      statusline = false,
      tabline = false,
      winbar = false,
    },
  },

  config = function(_, opts)
    require('dashboard').setup(opts)

    set_dashboard_highlights()

    local group = vim.api.nvim_create_augroup(
      'dashboard_highlights',
      {
        clear = true,
      }
    )

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = group,
      desc = 'Restore dashboard highlights',
      callback = set_dashboard_highlights,
    })
  end,
}
