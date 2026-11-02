-- Completion and snippets.
return {
  'hrsh7th/nvim-cmp',

  event = {
    'InsertEnter',
    'CmdlineEnter',
  },

  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
    'windwp/nvim-autopairs',

    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
    },
  },

  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    require('luasnip.loaders.from_snipmate').lazy_load()

    -- Reuse Puppet and EPP snippets when OpenVox assigns one of its EPP-specific filetypes.
    luasnip.filetype_extend('epuppet', {
      'epp',
      'puppet',
    })

    luasnip.filetype_extend('embeddedpuppet', {
      'epp',
      'puppet',
    })

    local source_labels = {
      buffer = 'Buffer',
      cmdline = 'Command',
      luasnip = 'Snippet',
      nvim_lsp = 'LSP',
      nvim_lsp_signature_help = 'Signature',
      path = 'Path',
    }

    local color_highlights = {}

    local function has_words_before()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local line = cursor[1]
      local column = cursor[2]

      if column == 0 then
        return false
      end

      local text = vim.api.nvim_buf_get_lines(
        0,
        line - 1,
        line,
        true
      )[1] or ''

      return text:sub(column, column):match('%s') == nil
    end

    local function documentation_text(completion_item)
      local documentation = completion_item.documentation

      if type(documentation) == 'string' then
        return documentation
      end

      if type(documentation) == 'table' then
        return documentation.value
      end

      if type(completion_item.detail) == 'string' then
        return completion_item.detail
      end

      return nil
    end

    local function apply_color_highlight(entry, vim_item)
      if vim_item.kind ~= 'Color' then
        return
      end

      local documentation = documentation_text(
        entry.completion_item
      )

      if not documentation then
        return
      end

      local red, green, blue = documentation:match(
        'rgb%(%s*(%d+)[,%s]+(%d+)[,%s]+(%d+)'
      )

      red = tonumber(red)
      green = tonumber(green)
      blue = tonumber(blue)

      if not red or not green or not blue then
        return
      end

      red = math.min(math.max(red, 0), 255)
      green = math.min(math.max(green, 0), 255)
      blue = math.min(math.max(blue, 0), 255)

      local color = string.format(
        '%02x%02x%02x',
        red,
        green,
        blue
      )

      local group = 'CmpItemColor' .. color

      if not color_highlights[group] then
        vim.api.nvim_set_hl(0, group, {
          fg = '#' .. color,
        })

        color_highlights[group] = true
      end

      vim_item.kind_hl_group = group
    end

    cmp.setup({
      preselect = cmp.PreselectMode.None,

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      view = {
        entries = {
          name = 'custom',
          selection_order = 'near_cursor',
        },
      },

      window = {
        completion = {
          col_offset = -2,
          side_padding = 0,
        },
      },

      formatting = {
        fields = {
          'kind',
          'abbr',
          'menu',
        },

        format = lspkind.cmp_format({
          mode = 'symbol',

          maxwidth = {
            abbr = 60,
            menu = 20,
          },

          ellipsis_char = '…',

          before = function(entry, vim_item)
            vim_item.menu = '  '
              .. (
                source_labels[entry.source.name]
                or entry.source.name
              )

            vim_item.abbr = vim_item.abbr:gsub('^%s+', '')

            apply_color_highlight(entry, vim_item)

            return vim_item
          end,
        }),
      },

      mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, {
          'i',
          's',
        }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          'i',
          's',
        }),

        ['<CR>'] = cmp.mapping.confirm({
          select = false,
        }),
      },

      sources = cmp.config.sources({
        {
          name = 'nvim_lsp',
          priority = 1000,
        },
        {
          name = 'nvim_lsp_signature_help',
          priority = 900,
        },
        {
          name = 'luasnip',
          priority = 750,
        },
        {
          name = 'path',
          priority = 500,
        },
      }, {
        {
          name = 'buffer',
          keyword_length = 3,
          max_item_count = 5,
        },
      }),
    })

    cmp.setup.cmdline({
      '/',
      '?',
    }, {
      mapping = cmp.mapping.preset.cmdline(),

      sources = {
        {
          name = 'buffer',
        },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),

      sources = cmp.config.sources({
        {
          name = 'path',
        },
      }, {
        {
          name = 'cmdline',

          option = {
            ignore_cmds = {
              'Man',
              '!',
            },
          },
        },
      }),

      matching = {
        disallow_symbol_nonprefix_matching = false,
      },
    })

    local cmp_autopairs =
      require('nvim-autopairs.completion.cmp')

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
