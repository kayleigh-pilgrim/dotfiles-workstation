-- Language Server Protocol configuration.
local servers = {
  'asm_lsp',
  'bashls',
  'basedpyright',
  'clangd',
  'cssls',
  'html',
  'intelephense',
  'jsonls',
  'lua_ls',
  'tailwindcss',
  'vtsls',
  'vue_ls',
  'yamlls',
}

return {
  'neovim/nvim-lspconfig',

  -- Mason recommends being set up during startup rather than being
  -- deferred until VeryLazy.
  lazy = false,

  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'b0o/schemastore.nvim',
    {
      'mason-org/mason.nvim',
      opts = {
        ui = {
          height = 0.8,
        },
      },
    },
    'mason-org/mason-lspconfig.nvim',
  },

  config = function()
    local api = vim.api
    local schemastore = require('schemastore')

    -- Advertise nvim-cmp completion capabilities to every LSP server.
    vim.lsp.config('*', {
      capabilities =
        require('cmp_nvim_lsp').default_capabilities(),
    })

    -- PHP
    --
    -- Keep only one PHP language server active. If phpactor.nvim is
    -- configured to start Phpactor as an LSP, remove intelephense from
    -- both the servers list and this setup.
    vim.lsp.config('intelephense', {})

    -- Vue, JavaScript, and TypeScript.
    --
    -- Vue Language Server 3 uses hybrid mode. vue_ls handles the
    -- template and style sections, while vtsls plus the Vue TypeScript
    -- plugin handles JavaScript and TypeScript inside Vue files.
    local vue_language_server_path = vim.fn.expand(
      '$MASON/packages/vue-language-server'
        .. '/node_modules/@vue/language-server'
    )

    local vue_typescript_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = {
        'vue',
      },
      configNamespace = 'typescript',
    }

    vim.lsp.config('vtsls', {
      filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
      },

      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_typescript_plugin,
            },
          },
        },
      },
    })

    vim.lsp.config('vue_ls', {})

    -- Tailwind CSS.
    vim.lsp.config('tailwindcss', {})

    -- JSON.
    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = {
            enable = true,
          },
        },
      },
    })

    -- YAML.
    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = '',
          },
          schemas = schemastore.yaml.schemas(),
        },
      },
    })

    -- Lua.
    vim.lsp.config('lua_ls', {
      on_init = function(client)
        local workspace_folders =
          client.workspace_folders

        if workspace_folders then
          local path = workspace_folders[1].name

          local has_luarc =
            vim.uv.fs_stat(path .. '/.luarc.json')
            or vim.uv.fs_stat(path .. '/.luarc.jsonc')

          if path ~= vim.fn.stdpath('config')
            and has_luarc
          then
            return
          end
        end

        client.config.settings.Lua =
          vim.tbl_deep_extend(
            'force',
            client.config.settings.Lua,
            {
              runtime = {
                version = 'LuaJIT',
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },

              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            }
          )
      end,

      settings = {
        Lua = {},
      },
    })

    -- Assembly
    vim.lsp.config("asm_lsp", {
      filetypes = {
        "asm",
        "nasm",
        "vmasm",
      },
      root_markers = {
        ".asm-lsp.toml",
        ".git",
      },
    })
    -- vim.lsp.enable("asm_lsp")

    -- The remaining servers use nvim-lspconfig defaults.
    vim.lsp.config('bashls', {})
    vim.lsp.config('basedpyright', {})
    vim.lsp.config('clangd', {})
    vim.lsp.config('cssls', {})
    vim.lsp.config('html', {})

    -- Install the selected servers through Mason, but enable them
    -- explicitly only after all custom configuration has been applied.
    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_enable = false,
    })

    vim.lsp.enable(servers)

    -- Buffer-local LSP mappings.
    local lsp_group = api.nvim_create_augroup(
      'user_lsp_attach',
      {
        clear = true,
      }
    )

    api.nvim_create_autocmd('LspAttach', {
      group = lsp_group,
      desc = 'Configure LSP mappings',
      callback = function(event)
        local function map(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, {
            buffer = event.buf,
            silent = true,
            desc = desc,
          })
        end

        map(
          '<leader>d',
          vim.diagnostic.open_float,
          'Show diagnostic'
        )

        map(
          'gd',
          '<cmd>Telescope lsp_definitions<CR>',
          'Go to definition'
        )

        map(
          'gi',
          '<cmd>Telescope lsp_implementations<CR>',
          'Go to implementation'
        )

        map(
          'gr',
          '<cmd>Telescope lsp_references<CR>',
          'Show references'
        )

        map(
          'gD',
          vim.lsp.buf.declaration,
          'Go to declaration'
        )

        map(
          'ga',
          vim.lsp.buf.code_action,
          'Code action'
        )

        map(
          'K',
          vim.lsp.buf.hover,
          'Show hover documentation'
        )

        map(
          '<leader>rn',
          vim.lsp.buf.rename,
          'Rename symbol'
        )

        map(
          '<leader>ds',
          '<cmd>Telescope lsp_document_symbols<CR>',
          'Document symbols'
        )

        map(
          '<leader>ws',
          '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',
          'Workspace symbols'
        )

        map(
          '<leader>lr',
          '<cmd>lsp restart<CR>',
          'Restart LSP clients'
        )
      end,
    })

    -- Diagnostic display.
    vim.diagnostic.config({
      virtual_text = false,
      severity_sort = true,
      update_in_insert = false,
      underline = true,

      float = {
        border = 'rounded',
        source = true,
      },

      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.INFO] = '',
          [vim.diagnostic.severity.HINT] = '',
        },
      },
    })
  end,
}
