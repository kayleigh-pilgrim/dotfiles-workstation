-- Tree-sitter parsers, highlighting, indentation, and text objects.
local ensure_installed = {
  'arduino',
  'asm',
  'bash',
  'blade',
  'c',
  'comment',
  'css',
  'diff',
  'dockerfile',
  'editorconfig',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'html',
  'http',
  'ini',
  'javascript',
  'json',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'passwd',
  'php',
  'php_only',
  'phpdoc',
  'puppet',
  'python',
  'query',
  'regex',
  'ruby',
  'rust',
  'scss',
  'solidity',
  'sql',
  'svelte',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'xml',
  'yaml',
}

return {
  -- The original repository was archived in April 2026. This
  -- community fork continues the main-branch rewrite.
  'neovim-treesitter/nvim-treesitter',

  lazy = false,
  build = ':TSUpdate',

  init = function()
    -- Register filetypes before the first matching buffer is opened.
    vim.filetype.add({
      pattern = {
        ['.*%.blade%.php'] = 'blade',
      },
    })

    -- There is no separate jsonc parser. Use the JSON parser for
    -- JSON-with-comments buffers.
    vim.treesitter.language.register('json', 'jsonc')

    -- Neovim sometimes uses nasm as filetype for Assembly, so register with same parser
    vim.treesitter.language.register('asm', {'nasm', 'vmasm'})
  end,

  dependencies = {
    'neovim-treesitter/treesitter-parser-registry',

    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
    },

    {
      'JoosepAlviste/nvim-ts-context-commentstring',

      opts = {
        -- Native Neovim commenting calculates the comment string
        -- only when it is needed.
        enable_autocmd = false,

        languages = {
          php = '// %s',
          php_only = '// %s',
        },

        custom_calculation = function(_, language_tree)
          if vim.bo.filetype ~= 'blade' then
            return nil
          end

          local language = language_tree:lang()

          if language == 'blade' or language == 'html' then
            return '{{-- %s --}}'
          end

          return '// %s'
        end,
      },
    },
  },

  config = function()
    local treesitter = require('nvim-treesitter')

    -- Calling install at startup is safe: parsers that are already
    -- installed are left alone.
    treesitter.install(ensure_installed)

    local group = vim.api.nvim_create_augroup(
      'user_treesitter',
      {
        clear = true,
      }
    )

    local indent_disabled = {
      yaml = true,
    }

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      desc = 'Enable Tree-sitter features when queries are available',

      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local language = vim.treesitter.language.get_lang(filetype)

        if not language then
          return
        end

        local started = pcall(
          vim.treesitter.start,
          event.buf,
          language
        )

        if not started or indent_disabled[filetype] then
          return
        end

        -- Only replace the filetype's indentation when this language
        -- actually supplies an indents query.
        local query_ok, indent_query = pcall(
          vim.treesitter.query.get,
          language,
          'indents'
        )

        if query_ok and indent_query then
          vim.bo[event.buf].indentexpr =
            "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Integrate context-sensitive comment strings with Neovim's
    -- built-in `gc` mappings without using CursorHold.
    if not vim.g.user_context_commentstring_configured then
      local get_option = vim.filetype.get_option

      vim.filetype.get_option = function(filetype, option)
        if option == 'commentstring' then
          local calculated =
            require(
              'ts_context_commentstring.internal'
            ).calculate_commentstring()

          if calculated then
            return calculated
          end
        end

        return get_option(filetype, option)
      end

      vim.g.user_context_commentstring_configured = true
    end

    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,

        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },

        include_surrounding_whitespace = false,
      },
    })

    local select_textobject =
      require(
        'nvim-treesitter-textobjects.select'
      ).select_textobject

    local function map_textobject(lhs, capture, description)
      vim.keymap.set({
        'x',
        'o',
      }, lhs, function()
        select_textobject(capture, 'textobjects')
      end, {
        desc = description,
      })
    end

    map_textobject(
      'if',
      '@function.inner',
      'Inside function'
    )

    map_textobject(
      'af',
      '@function.outer',
      'Around function'
    )

    map_textobject(
      'ia',
      '@parameter.inner',
      'Inside argument'
    )

    map_textobject(
      'aa',
      '@parameter.outer',
      'Around argument'
    )

    map_textobject(
      'ic',
      '@class.inner',
      'Inside class'
    )

    map_textobject(
      'ac',
      '@class.outer',
      'Around class'
    )
  end,
}
