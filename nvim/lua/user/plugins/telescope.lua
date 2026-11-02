-- Fuzzy finding, project search, and Telescope-backed selections.
local root_markers = {
  '.git',
  'artisan',
  'composer.json',
  'package.json',
  'pyproject.toml',
  'Cargo.toml',
  'Makefile',
}

local function project_root()
  return vim.fs.root(0, root_markers) or vim.uv.cwd()
end

local function find_files(options)
  return function()
    local builtin = require('telescope.builtin')

    builtin.find_files(vim.tbl_extend(
      'force',
      {
        cwd = project_root(),
      },
      options or {}
    ))
  end
end

local function live_grep(options)
  return function()
    local telescope = require('telescope')

    telescope.extensions.live_grep_args.live_grep_args(
      vim.tbl_extend(
        'force',
        {
          cwd = project_root(),
        },
        options or {}
      )
    )
  end
end

return {
  'nvim-telescope/telescope.nvim',

  version = '*',

  event = 'VeryLazy',

  cmd = {
    'Telescope',
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',

    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      version = '^1.0.0',
    },

    'nvim-telescope/telescope-ui-select.nvim',

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },

  keys = {
    {
      '<leader>f',
      find_files({
        prompt_title = 'Project Files',
      }),
      desc = 'Find project files',
    },
    {
      '<leader>F',
      find_files({
        no_ignore = true,
        prompt_title = 'All Project Files',
      }),
      desc = 'Find all project files',
    },
    {
      '<leader>b',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find buffers',
    },
    {
      '<leader>g',
      live_grep({
        prompt_title = 'Grep Project',
      }),
      desc = 'Grep project',
    },
    {
      '<leader>G',
      live_grep({
        additional_args = {
          '--no-ignore',
        },
        prompt_title = 'Grep All Files',
      }),
      desc = 'Grep all project files',
    },
    {
      '<leader>h',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Search help',
    },
    {
      '<leader>s',
      function()
        require('telescope.builtin').lsp_document_symbols()
      end,
      desc = 'Document symbols',
    },
  },

  config = function()
    local actions = require('telescope.actions')
    local live_grep_actions = require('telescope-live-grep-args.actions')
    local telescope = require('telescope')
    local themes = require('telescope.themes')

    local grep_arguments = {
      'rg',
      '--hidden',
      '--glob',
      '!**/.git/**',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    }

    telescope.setup({
      defaults = {
        dynamic_preview_title = true,

        path_display = {
          truncate = 1,
        },

        prompt_prefix = '   ',
        selection_caret = '  ',

        sorting_strategy = 'ascending',

        layout_config = {
          prompt_position = 'top',
        },

        preview = {
          filesize_limit = 1,
          timeout = 200,
          msg_bg_fillchar = ' ',
        },

        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<C-Down>'] = actions.cycle_history_next,
            ['<C-Up>'] = actions.cycle_history_prev,
          },
        },
      },

      pickers = {
        find_files = {
          hidden = true,

          -- Return a new table for every picker invocation because
          -- Telescope appends options such as --hidden and --no-ignore.
          find_command = function()
            return {
              'rg',
              '--files',
              '--color',
              'never',
              '--glob',
              '!**/.git/**',
            }
          end,
        },

        buffers = {
          previewer = false,
          sort_mru = true,
          ignore_current_buffer = true,

          layout_config = {
            width = 80,
          },
        },

        oldfiles = {
          prompt_title = 'History',
        },

        lsp_references = {
          previewer = false,
        },

        lsp_definitions = {
          previewer = false,
        },

        lsp_document_symbols = {
          symbol_width = 55,
        },
      },

      extensions = {
        fzf = {
          case_mode = 'smart_case',
          fuzzy = true,
          override_file_sorter = true,
          override_generic_sorter = true,
        },

        live_grep_args = {
          auto_quoting = true,
          vimgrep_arguments = grep_arguments,

          mappings = {
            i = {
              ['<C-k>'] = live_grep_actions.quote_prompt(),
              ['<C-space>'] =
                live_grep_actions.to_fuzzy_refine,
            },
          },
        },

        ['ui-select'] = themes.get_dropdown(),
      },
    })

    telescope.load_extension('fzf')
    telescope.load_extension('live_grep_args')
    telescope.load_extension('ui-select')
  end,
}
