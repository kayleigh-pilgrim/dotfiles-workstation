-- Display open buffers as tabs.
local inactive_bg = {
  bg = {
    attribute = 'bg',
    highlight = 'StatusLineNC',
  },
}

local statusline_bg = {
  attribute = 'bg',
  highlight = 'StatusLine',
}

local function delete_buffer(bufnr)
  require('mini.bufremove').delete(bufnr, false)
end

return {
  'akinsho/bufferline.nvim',
  version = '*',

  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  opts = {
    options = {
      close_command = delete_buffer,
      right_mouse_command = delete_buffer,

      indicator = {
        style = 'none',
      },

      diagnostics = 'nvim_lsp',

      diagnostics_indicator = function(count, level)
        local icon = level:match('error') and ' ' or ' '

        return ' ' .. icon .. count
      end,

      show_close_icon = false,
      tab_size = 0,
      max_name_length = 25,

      offsets = {
        {
          filetype = 'neo-tree',
          text = function()
            return '  '
              .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
          end,
          highlight = 'Directory',
          text_align = 'left',
          separator = true,
        },
      },

      hover = {
        enabled = true,
        delay = 150,
        reveal = {
          'close',
        },
      },

      separator_style = 'slant',
      modified_icon = ' ',

      custom_areas = {
        left = function()
          return {
            {
              text = ' ',
            },
          }
        end,

        right = function()
          return {
            {
              text = '    ',
              fg = '#8fff6d',
            },
          }
        end,
      },
    },

    highlights = {
      fill = {
        bg = statusline_bg,
      },

      background = inactive_bg,
      close_button = inactive_bg,
      diagnostic = inactive_bg,
      diagnostic_visible = inactive_bg,
      modified = inactive_bg,
      modified_visible = inactive_bg,
      hint = inactive_bg,
      hint_visible = inactive_bg,
      info = inactive_bg,
      info_visible = inactive_bg,
      warning = inactive_bg,
      warning_visible = inactive_bg,
      error = inactive_bg,
      error_visible = inactive_bg,
      hint_diagnostic = inactive_bg,
      hint_diagnostic_visible = inactive_bg,
      info_diagnostic = inactive_bg,
      info_diagnostic_visible = inactive_bg,
      warning_diagnostic = inactive_bg,
      warning_diagnostic_visible = inactive_bg,
      error_diagnostic = inactive_bg,
      error_diagnostic_visible = inactive_bg,
      duplicate = inactive_bg,
      duplicate_visible = inactive_bg,

      separator = {
        fg = statusline_bg,
        bg = inactive_bg.bg,
      },

      separator_selected = {
        fg = statusline_bg,
      },

      separator_visible = {
        fg = statusline_bg,
      },

      trunc_marker = {
        bg = statusline_bg,
      },

      -- Tabpages.
      tab = inactive_bg,

      tab_separator = {
        fg = statusline_bg,
        bg = inactive_bg.bg,
      },

      tab_separator_selected = {
        fg = statusline_bg,
      },
    },
  },
}
