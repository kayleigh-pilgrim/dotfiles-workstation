-- Create code snapshots.
return {
  'mistricky/codesnap.nvim',
  version = 'v2.*',

  cmd = {
    'CodeSnap',
    'CodeSnapASCII',
    'CodeSnapHighlight',
    'CodeSnapSave',
    'CodeSnapSaveHighlight',
  },

  opts = {
    show_line_number = true,
    show_workspace = true,

    snapshot_config = {
      window = {
        mac_window_bar = false,
      },

      code_config = {
        font_family = 'JetBrainsMono Nerd Font',

        breadcrumbs = {
          enable = true,
          separator = '/',
          font_family = 'JetBrainsMono Nerd Font',
        },
      },

      watermark = {
        content = '',
        font_family = 'JetBrainsMono Nerd Font',
      },
    },
  },
}
