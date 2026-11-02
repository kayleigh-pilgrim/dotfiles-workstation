-- Asynchronous linting.
return {
  'mfussenegger/nvim-lint',

  event = {
    'BufReadPost',
    'BufNewFile',
  },

  config = function()
    local lint = require('lint')

    -- Bind eslint_d to the Neovim process so its daemon exits when
    -- Neovim closes.
    vim.env.ESLINT_D_PPID = vim.fn.getpid()

    local openvox_pattern =
      '(.+):(%d+):(%d+):(%l+):(.+):(.+)'

    local openvox_groups = {
      'file',
      'lnum',
      'col',
      'severity',
      'code',
      'message',
    }

    local openvox_severities = {
      error = vim.diagnostic.severity.ERROR,
      warning = vim.diagnostic.severity.WARN,
    }

    lint.linters.openvox_lint = {
      cmd = 'openvox-lint',
      stdin = false,
      args = {
        '--log-format',
        '%{path}:%{line}:%{column}:%{kind}:%{check}:%{message}',
      },
      ignore_exitcode = true,
      parser = require('lint.parser').from_pattern(
        openvox_pattern,
        openvox_groups,
        openvox_severities,
        {
          source = 'openvox-lint',
        }
      ),
    }

    local puppet_linters = {}

    if vim.fn.executable('openvox-lint') == 1 then
      puppet_linters = {
        'openvox_lint',
      }
    elseif vim.fn.executable('puppet-lint') == 1 then
      puppet_linters = {
        'puppet-lint',
      }
    end

    lint.linters_by_ft = {
      -- JavaScript, TypeScript, React, and Vue.
      javascript = {
        'eslint_d',
      },
      javascriptreact = {
        'eslint_d',
      },
      typescript = {
        'eslint_d',
      },
      typescriptreact = {
        'eslint_d',
      },
      vue = {
        'eslint_d',
      },

      -- PHP.
      php = {
        'phpstan',
      },

      -- Python.
      python = {
        'ruff',
      },

      -- Shell scripts.
      sh = {
        'shellcheck',
      },
      bash = {
        'shellcheck',
      },

      -- Lua.
      lua = {
        'luacheck',
      },

      -- Puppet manifests.
      puppet = puppet_linters,

      -- Solidity.
      solidity = {
        'solhint',
      },

      -- C and C++ are intentionally omitted. clangd already provides
      -- diagnostics, while clang-tidy can be expensive on every save.
      --
      -- Rust is intentionally omitted. rust-analyzer or rustaceanvim
      -- should run Clippy with project context instead.
      --
      -- SQL is intentionally omitted until a dialect-aware linter such
      -- as SQLFluff is configured per project.
    }

    local group = vim.api.nvim_create_augroup(
      'user_lint',
      {
        clear = true,
      }
    )

    vim.api.nvim_create_autocmd({
      'BufReadPost',
      'BufWritePost',
    }, {
      group = group,
      desc = 'Lint the current buffer',
      callback = function(event)
        if vim.bo[event.buf].buftype ~= '' then
          return
        end

        lint.try_lint()
      end,
    })

    vim.api.nvim_create_user_command(
      'Lint',
      function()
        lint.try_lint()
      end,
      {
        desc = 'Lint the current buffer',
      }
    )

    -- The plugin may be loaded after the initial BufEnter event.
    vim.schedule(function()
      local buffer = vim.api.nvim_get_current_buf()

      if vim.api.nvim_buf_is_valid(buffer)
        and vim.bo[buffer].buftype == ''
      then
        lint.try_lint()
      end
    end)
  end,
}
