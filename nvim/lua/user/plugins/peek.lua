-- Preview Markdown files in a browser.
return {
  'toppair/peek.nvim',

  build = 'deno task --quiet build:fast',

  cmd = {
    'PeekOpen',
    'PeekClose',
  },

  config = function()
    local peek = require('peek')

    peek.setup({
      app = 'browser',
      theme = 'dark',
      syntax = true,
      update_on_change = true,
      close_on_bdelete = true,
    })

    vim.api.nvim_create_user_command(
      'PeekOpen',
      function()
        if vim.bo.filetype ~= 'markdown' then
          vim.notify(
            'Peek is only available for Markdown buffers',
            vim.log.levels.WARN
          )
          return
        end

        peek.open()
      end,
      {
        desc = 'Open Markdown preview',
      }
    )

    vim.api.nvim_create_user_command(
      'PeekClose',
      peek.close,
      {
        desc = 'Close Markdown preview',
      }
    )
  end,
}
