-- Tokyo Night colour scheme and interface highlights.
return {
  'folke/tokyonight.nvim',

  lazy = false,
  priority = 1000,

  opts = {
    -- Keep the selected variant explicit rather than relying on the
    -- plugin's default.
    -- Options are moon, storm, night, day
    -- style = 'moon',
    style = 'night',

    terminal_colors = true,

    styles = {
      sidebars = 'dark',
      floats = 'dark',
    },

    on_colors = function(colors)
      -- TokyoNight's GitSigns groups read from colors.git.
      colors.git.add = colors.teal
      colors.git.change = colors.purple
      colors.git.delete = colors.red
    end,

    on_highlights = function(hl, colors)
      local util = require('tokyonight.util')

      local prompt = '#2d3149'
      local sidebar = util.darken(
        colors.bg_dark,
        0.85,
        '#000000'
      )
      local inactive_tab = util.darken(
        colors.bg_dark,
        0.75,
        '#000000'
      )
      local separator = util.darken(
        colors.bg_dark,
        0.85,
        '#000000'
      )

      -- Bufferline links its backgrounds to StatusLine and
      -- StatusLineNC in bufferline.lua.
      hl.StatusLine = {
        bg = util.darken(
          colors.bg_dark,
          0.98,
          '#000000'
        ),
        fg = colors.fg_dark,
      }

      hl.StatusLineNC = {
        bg = colors.bg_dark,
        fg = colors.fg_gutter,
      }

      -- Line numbers.
      hl.LineNrAbove = {
        fg = colors.fg_gutter,
      }

      hl.LineNr = {
        fg = util.lighten(
          colors.fg_gutter,
          0.7
        ),
      }

      hl.LineNrBelow = {
        fg = colors.fg_gutter,
      }

      -- Messages.
      hl.MsgArea = {
        bg = separator,
      }

      -- Spelling.
      hl.SpellBad = {
        undercurl = true,
        sp = '#7f3a43',
      }

      -- Telescope.
      hl.TelescopeNormal = {
        bg = colors.bg_dark,
        fg = colors.fg_dark,
      }

      hl.TelescopeBorder = {
        bg = colors.bg_dark,
        fg = colors.bg_dark,
      }

      hl.TelescopePromptNormal = {
        bg = prompt,
      }

      hl.TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
      }

      hl.TelescopePromptTitle = {
        bg = prompt,
        fg = colors.fg_dark,
      }

      hl.TelescopePreviewTitle = {
        bg = colors.bg_dark,
        fg = colors.bg_dark,
      }

      hl.TelescopeResultsTitle = {
        bg = colors.bg_dark,
        fg = colors.bg_dark,
      }

      -- Neo-tree.
      hl.NeoTreeNormal = {
        bg = sidebar,
      }

      hl.NeoTreeNormalNC = {
        bg = sidebar,
      }

      hl.NeoTreeWinSeparator = {
        bg = sidebar,
        fg = sidebar,
      }

      hl.NeoTreeIndentMarker = {
        fg = colors.bg_highlight,
      }

      hl.NeoTreeFileNameOpened = {
        fg = colors.orange,
        bold = true,
      }

      hl.NeoTreeTabActive = {
        bg = colors.bg_dark,
        fg = colors.fg,
        bold = true,
      }

      hl.NeoTreeTabInactive = {
        bg = inactive_tab,
        fg = colors.comment,
      }

      hl.NeoTreeTabSeparatorActive = {
        bg = colors.bg_dark,
        fg = separator,
      }

      hl.NeoTreeTabSeparatorInactive = {
        bg = inactive_tab,
        fg = separator,
      }

      -- GitSigns.
      hl.GitSignsCurrentLineBlame = {
        fg = colors.fg_gutter,
      }

      -- Indent Blankline.
      hl.IblIndent = {
        fg = util.darken(
          colors.bg_highlight,
          0.30
        ),
      }

      hl.IblScope = {
        fg = util.darken(
          colors.bg_highlight,
          0.80
        ),
      }

      -- Floaterm.
      hl.Floaterm = {
        -- bg = prompt,
        bg = dark,
      }

      hl.FloatermBorder = {
        bg = prompt,
        fg = prompt,
      }

      -- Copilot ghost text.
      hl.CopilotSuggestion = {
        fg = colors.comment,
      }
    end,
  },

  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme('tokyonight')
  end,
}
