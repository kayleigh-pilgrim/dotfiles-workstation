-- Puppet and OpenVox syntax, indentation, and filetype support.
return {
  'cvquesty/vim-openvox',

  lazy = false,

  init = function()
    -- nvim-lint handles Puppet linting. vim-openvox currently uses
    -- Vim's job_start() API, which is not available in Neovim.
    vim.g.openvox_auto_lint = 0

    -- Do not rewrite arrow alignment automatically when saving.
    vim.g.openvox_auto_align = 0

    -- Avoid buffer-local mappings such as <LocalLeader>f overriding
    -- Telescope and the rest of the Neovim keymap configuration.
    vim.g.openvox_no_mappings = 1
  end,
}
