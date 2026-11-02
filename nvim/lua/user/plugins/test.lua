-- Run the nearest test, current file, or complete test suite.
local project_markers = {
  '.git',
  'artisan',
  'composer.json',
  'package.json',
  'pyproject.toml',
  'Cargo.toml',
  'Makefile',
}

return {
  'vim-test/vim-test',

  version = '*',

  cmd = {
    'TestNearest',
    'TestFile',
    'TestSuite',
    'TestLast',
    'TestVisit',
  },

  keys = {
    {
      '<leader>tn',
      '<cmd>TestNearest<CR>',
      desc = 'Run nearest test',
    },
    {
      '<leader>tf',
      '<cmd>TestFile<CR>',
      desc = 'Run test file',
    },
    {
      '<leader>ts',
      '<cmd>TestSuite<CR>',
      desc = 'Run test suite',
    },
    {
      '<leader>tl',
      '<cmd>TestLast<CR>',
      desc = 'Run last test',
    },
    {
      '<leader>tv',
      '<cmd>TestVisit<CR>',
      desc = 'Visit last test',
    },
  },

  init = function()
    -- Keep one reusable terminal split for test output.
    vim.g['test#strategy'] = 'neovim_sticky'
    vim.g['test#neovim#term_position'] = 'vert'
    vim.g['test#preserve_screen'] = 0
    vim.g['test#neovim_sticky#kill_previous'] = 1
    vim.g['test#neovim_sticky#reopen_window'] = 1

    -- Resolve the current project independently of Neovim's working
    -- directory. This replaces the project-root behaviour previously
    -- supplied by vim-rooter.
    _G.VimTestProjectRoot = function()
      local buffer = vim.api.nvim_get_current_buf()
      local name = vim.api.nvim_buf_get_name(buffer)
      local start = name ~= '' and name or vim.uv.cwd()
      local root = vim.fs.root(start, project_markers)

      return root or vim.uv.cwd()
    end

    vim.cmd([[
      function! VimTestProjectRoot() abort
        return v:lua.VimTestProjectRoot()
      endfunction
    ]])
    vim.g['test#project_root'] =
      vim.fn['function']('VimTestProjectRoot')
  end,
}
