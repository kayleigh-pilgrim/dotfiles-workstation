local api = vim.api
local map = vim.keymap.set

local group = api.nvim_create_augroup('user_autocmds', {
  clear = true,
})

-- Briefly highlight text after yanking it.
api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight yanked text',
  callback = function()
    if vim.hl and vim.hl.hl_op then
      vim.hl.hl_op({
        timeout = 150,
      })
    else
      vim.highlight.on_yank({
        timeout = 150,
      })
    end
  end,
})

-- Disable the ":" command-line history window without mapping q:.
--
-- Mapping q: directly can delay the normal q command used for recording
-- macros because Neovim has to wait to see whether ":" follows.
api.nvim_create_autocmd('CmdwinEnter', {
  group = group,
  pattern = ':',
  desc = 'Disable command-line history window',
  callback = function()
    local window = api.nvim_get_current_win()

    vim.schedule(function()
      if api.nvim_win_is_valid(window) then
        pcall(api.nvim_win_close, window, true)
      end
    end)
  end,
})

local semicolon_filetypes = {
  c = true,
  cpp = true,
  javascript = true,
  javascriptreact = true,
  php = true,
  rust = true,
  solidity = true,
  sql = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
}

local comma_filetypes = {
  c = true,
  cpp = true,
  embeddedpuppet = true,
  epp = true,
  epuppet = true,
  javascript = true,
  javascriptreact = true,
  lua = true,
  php = true,
  puppet = true,
  python = true,
  rust = true,
  solidity = true,
  sql = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
}

-- Add punctuation at the end of the current line in filetypes where it
-- makes sense. These are deliberately not global because ";;" has a
-- special meaning in Bash case statements.
api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = '*',
  desc = 'Create filetype-specific punctuation mappings',
  callback = function(event)
    local filetype = vim.bo[event.buf].filetype

    if semicolon_filetypes[filetype] then
      map('i', ';;', '<Esc>A;<Esc>', {
        buffer = event.buf,
        desc = 'Append semicolon',
      })
    end

    if comma_filetypes[filetype] then
      map('i', ',,', '<Esc>A,<Esc>', {
        buffer = event.buf,
        desc = 'Append comma',
      })
    end
  end,
})

-- Allow common temporary and informational windows to be closed with q.
api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = {
    'checkhealth',
    'help',
    'lspinfo',
    'man',
    'qf',
    'startuptime',
  },
  desc = 'Configure temporary windows',
  callback = function(event)
    vim.bo[event.buf].buflisted = false

    map('n', 'q', '<cmd>close<CR>', {
      buffer = event.buf,
      silent = true,
      desc = 'Close window',
    })
  end,
})

-- Detect files that were changed by another program, such as Git,
-- formatters, build tools, or an external editor.
api.nvim_create_autocmd({
  'FocusGained',
  'TermClose',
  'TermLeave',
}, {
  group = group,
  desc = 'Check for files changed outside Neovim',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- Disable spell checking inside terminal windows.
api.nvim_create_autocmd('TermOpen', {
  group = group,
  desc = 'Disable spell checking in terminals',
  callback = function()
    vim.opt_local.spell = false
  end,
})
