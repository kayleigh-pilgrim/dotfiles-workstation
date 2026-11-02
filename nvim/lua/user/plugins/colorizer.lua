-- Highlight color values in source files.
return {
  'catgoose/nvim-colorizer.lua',

  event = {
    'BufReadPre',
    'BufNewFile',
  },

  opts = {
    filetypes = {
      '*',

      css = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      scss = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      sass = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      less = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      html = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      blade = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      vue = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      javascript = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      javascriptreact = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      typescript = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },

      typescriptreact = {
        parsers = {
          css = true,
          names = {
            enable = false,
          },
        },
      },
    },

    options = {
      parsers = {
        names = {
          enable = false,
        },

        hex = {
          default = true,
          rrggbbaa = true,
        },
      },

      display = {
        mode = 'background',
      },
    },
  },
}
