-- Git signs, hunk actions, and line blame.
local signs = {
  add = {
    text = '│',
  },
  change = {
    text = '│',
  },
  delete = {
    text = '_',
  },
  topdelete = {
    text = '‾',
  },
  changedelete = {
    text = '┄',
  },
  untracked = {
    text = '┊',
  },
}

return {
  'lewis6991/gitsigns.nvim',

  event = {
    'BufReadPre',
    'BufNewFile',
  },

  opts = {
    signs = signs,
    signs_staged = vim.deepcopy(signs),

    preview_config = {
      border = 'rounded',
    },

    current_line_blame = true,

    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 500,
      ignore_whitespace = true,
      use_focus = true,
    },

    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          silent = true,
          desc = desc,
        })
      end

      map('n', ']h', function()
        gitsigns.nav_hunk('next')
      end, 'Next Git hunk')

      map('n', '[h', function()
        gitsigns.nav_hunk('prev')
      end, 'Previous Git hunk')

      map('n', 'gs', gitsigns.stage_hunk, 'Stage Git hunk')

      map('x', 'gs', function()
        gitsigns.stage_hunk({
          vim.fn.line('.'),
          vim.fn.line('v'),
        })
      end, 'Stage selected Git hunk')

      map(
        'n',
        'gS',
        gitsigns.undo_stage_hunk,
        'Undo staged Git hunk'
      )

      map(
        'n',
        'gp',
        gitsigns.preview_hunk,
        'Preview Git hunk'
      )

      map('n', 'gb', function()
        gitsigns.blame_line({
          full = true,
        })
      end, 'Show Git blame')

      map(
        'n',
        'gB',
        gitsigns.toggle_current_line_blame,
        'Toggle Git line blame'
      )

      map(
        {
          'o',
          'x',
        },
        'ih',
        gitsigns.select_hunk,
        'Git hunk'
      )
    end,
  },
}
