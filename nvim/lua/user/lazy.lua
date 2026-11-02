-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  local repository = 'https://github.com/folke/lazy.nvim.git'

  local output = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    repository,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      {
        'Failed to clone lazy.nvim:\n',
        'ErrorMsg',
      },
      {
        output,
        'WarningMsg',
      },
      {
        '\nPress any key to exit...',
      },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup('user.plugins', {
-- Do not allow projects to add plugins through .lazy.lua files.
  local_spec = false,

  checker = {
    enabled = true,
    notify = false,
    --frequency = 86400, -- I find the default of 1 hour fine considering notify is set to false
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  install = {
    colorscheme = {
      'tokyonight',
      'habamax', -- Built-in fallback before tokyonight becomes available
    },
  },
})
