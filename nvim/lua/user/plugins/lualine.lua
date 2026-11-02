-- Status line.
local function indentation()
  local width = vim.bo.shiftwidth

  if width == 0 then
    width = vim.bo.tabstop
  end

  local icon = vim.bo.expandtab and '␠ ' or '⇥ '

  return icon .. width
end

local function non_default_encoding()
  local encoding = vim.bo.fileencoding

  return encoding ~= ''
    and encoding:lower() ~= 'utf-8'
end

local function non_unix_fileformat()
  return vim.bo.fileformat ~= 'unix'
end

return {
  'nvim-lualine/lualine.nvim',

  lazy = false,

  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  opts = function()
    local lazy_status = require('lazy.status')

    return {
      options = {
        section_separators = '',
        component_separators = '',
        globalstatus = true,
        theme = 'auto',
      },

      sections = {
        lualine_a = {
          'mode',
        },

        lualine_b = {
          'branch',

          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
          },

          {
            'diagnostics',
            sources = {
              'nvim_diagnostic',
            },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },

          {
            'lsp_status',
            icon = '󰒋',
            show_name = true,
            symbols = {
              spinner = {
                '⠋',
                '⠙',
                '⠹',
                '⠸',
                '⠼',
                '⠴',
                '⠦',
                '⠧',
                '⠇',
                '⠏',
              },
              done = '✓',
              separator = ', ',
            },
          },
        },

        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = {
              modified = ' ●',
              readonly = ' ',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
        },

        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = {
              fg = '#ff9e64',
            },
          },
        },

        lualine_y = {
          'filetype',

          {
            indentation,
            color = 'Comment',
          },

          {
            'encoding',
            cond = non_default_encoding,
          },

          {
            'fileformat',
            cond = non_unix_fileformat,
          },
        },

        lualine_z = {
          'searchcount',
          'selectioncount',
          'location',
          'progress',
        },
      },

      extensions = {
        'fugitive',
        'lazy',
        'mason',
        'neo-tree',
        'oil',
        'quickfix',
      },
    }
  end,
}
