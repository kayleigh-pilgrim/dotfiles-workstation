-- File tree sidebar.
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',

  cmd = {
    'Neotree',
  },

  keys = {
    {
      '<leader>n',
      '<cmd>Neotree reveal toggle<CR>',
      desc = 'Toggle file tree',
    },
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',

    {
      's1n7ax/nvim-window-picker',
      name = 'window-picker',
      version = '2.*',

      opts = {
        -- Floating labels work reliably with globalstatus and cmdheight=0.
        hint = 'floating-letter',

        filter_rules = {
          autoselect_one = true,
          include_current_win = false,
          include_unfocusable_windows = false,

          bo = {
            filetype = {
              'neo-tree',
              'neo-tree-popup',
              'notify',
              'snacks_notif',
            },

            buftype = {
              'terminal',
              'quickfix',
            },
          },
        },
      },
    },
  },

  opts = {
    close_if_last_window = true,
    hide_root_node = true,

    sources = {
      'filesystem',
      'buffers',
      'git_status',
      'document_symbols',
    },

    source_selector = {
      winbar = true,
      statusline = false,

      sources = {
        {
          source = 'filesystem',
          display_name = ' 󰉓 Files ',
        },
        {
          source = 'buffers',
          display_name = ' 󰈚 Buffers ',
        },
        {
          source = 'git_status',
          display_name = ' 󰊢 Git ',
        },
        {
          source = 'document_symbols',
          display_name = ' 󰘦 Symbols ',
        },
      },

      separator = {
        left = '',
        right = '',
      },

      show_separator_on_edge = true,

      highlight_tab = 'NeoTreeTabInactive',
      highlight_tab_active = 'NeoTreeTabActive',
      highlight_background = 'StatusLine',
      highlight_separator = 'NeoTreeTabSeparatorInactive',
      highlight_separator_active = 'NeoTreeTabSeparatorActive',
    },

    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute({
            action = 'close',
          })
        end,
      },
    },

    default_component_configs = {
      indent = {
        padding = 0,
      },

      name = {
        use_git_status_colors = false,
        highlight_opened_files = true,
      },
    },

    window = {
      mappings = {
        ['<cr>'] = 'open_with_window_picker',
      },
    },

    filesystem = {
      -- Detect files changed outside Neovim without requiring a manual refresh.
      use_libuv_file_watcher = true,

      filtered_items = {
        hide_dotfiles = false,

        hide_by_name = {
          '.git',
        },
      },

      group_empty_dirs = false,
    },
  },
}
