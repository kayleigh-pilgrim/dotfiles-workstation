-- Format source files with external formatters or an LSP fallback.
local web_formatters = {
  'prettierd',
  'prettier',
  stop_after_first = true,
}

return {
  'stevearc/conform.nvim',

  event = {
    'BufWritePre',
  },

  cmd = {
    'ConformInfo',
  },

  opts = {
    formatters_by_ft = {

      -- Lua
      lua = {
        'stylua',
      },

      -- PHP and Laravel
      php = {
        'pint',
      },
      blade = {
        'blade-formatter',
      },

      -- C and C++
      c = {
        'clang_format',
      },
      cpp = {
        'clang_format',
      },

      -- Python
      python = {
        'ruff_organize_imports',
        'ruff_format',
      },

      -- Rust
      rust = {
        'rustfmt',
      },

      -- Shell
      sh = {
        'shfmt',
      },
      bash = {
        'shfmt',
      },

      -- Solidity
      solidity = {
        'forge_fmt',
      },

      -- JavaScript, TypeScript, React, Vue, CSS and related formats
      javascript = web_formatters,
      javascriptreact = web_formatters,
      typescript = web_formatters,
      typescriptreact = web_formatters,
      vue = web_formatters,
      html = web_formatters,
      css = web_formatters,
      scss = web_formatters,
      less = web_formatters,
      json = web_formatters,
      jsonc = web_formatters,
      yaml = web_formatters,
      markdown = web_formatters,
    },

    format_on_save = function(bufnr)
      local buffer_setting =
        vim.b[bufnr].disable_autoformat

      if buffer_setting == true then
        return
      end

      if buffer_setting == nil
        and vim.g.disable_autoformat
      then
        return
      end

      return {
        timeout_ms = 1000,
        lsp_format = 'fallback',
      }
    end,
  },

  init = function()
    vim.api.nvim_create_user_command(
      'FormatDisable',
      function(args)
        if args.bang then
          vim.b.disable_autoformat = true

          vim.notify(
            'Disabled formatting for the current buffer'
          )
        else
          vim.g.disable_autoformat = true

          vim.notify('Disabled formatting globally')
        end
      end,
      {
        bang = true,
        desc = 'Disable format-on-save',
      }
    )

    vim.api.nvim_create_user_command(
      'FormatEnable',
      function(args)
        if args.bang then
          vim.b.disable_autoformat = false

          vim.notify(
            'Enabled formatting for the current buffer'
          )
        else
          vim.g.disable_autoformat = false

          vim.notify('Enabled formatting globally')
        end
      end,
      {
        bang = true,
        desc = 'Enable format-on-save',
      }
    )
  end,
}
