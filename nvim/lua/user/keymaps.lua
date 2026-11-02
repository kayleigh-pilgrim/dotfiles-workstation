-- Space is my leader.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- Clear search highlighting.
map('n', '<Esc>', '<cmd>nohlsearch<CR>', {
  desc = 'Clear search highlighting',
})

-- Use normal gf behaviour when possible, but create the file when it
-- does not exist.
map('n', 'gf', function()
  local found = pcall(vim.cmd.normal, {
    args = { 'gf' },
    bang = true,
  })

  if found then
    return
  end

  local path = vim.fn.expand('<cfile>')

  if path == '' then
    return
  end

  vim.api.nvim_cmd({
    cmd = 'edit',
    args = { path },
  }, {})
end, {
  desc = 'Go to or create file under cursor',
})

-- Reselect the visual selection after indenting.
map('x', '<', '<gv', {
  desc = 'Indent selection left',
})

map('x', '>', '>gv', {
  desc = 'Indent selection right',
})

-- Maintain the cursor position when yanking a visual selection.
local function yank_without_moving(command)
  return function()
    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.cmd.normal({
      args = { command },
      bang = true,
    })

    vim.api.nvim_win_set_cursor(0, cursor)
  end
end

map('x', 'y', yank_without_moving('y'), {
  desc = 'Yank selection without moving cursor',
})

map('x', 'Y', yank_without_moving('Y'), {
  desc = 'Yank lines without moving cursor',
})

-- When text is wrapped, move by display rows unless a count is provided.
map('n', 'k', function()
  return vim.v.count == 0 and 'gk' or 'k'
end, {
  expr = true,
  desc = 'Move up by display line',
})

map('n', 'j', function()
  return vim.v.count == 0 and 'gj' or 'j'
end, {
  expr = true,
  desc = 'Move down by display line',
})

-- Replace a visual selection without overwriting the unnamed register.
map('x', 'p', 'P', {
  desc = 'Paste without replacing register',
})

-- Open the current file with the operating system's default program.
map('n', '<leader>x', function()
  local path = vim.api.nvim_buf_get_name(0)

  if path == '' then
    vim.notify(
      'The current buffer is not associated with a file',
      vim.log.levels.WARN
    )
    return
  end

  local _, err = vim.ui.open(path)

  if err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, {
  desc = 'Open current file externally',
})

-- Resize windows with the arrow keys.
map('n', '<C-Up>', '<cmd>resize +2<CR>', {
  desc = 'Increase window height',
})

map('n', '<C-Down>', '<cmd>resize -2<CR>', {
  desc = 'Decrease window height',
})

map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', {
  desc = 'Decrease window width',
})

map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', {
  desc = 'Increase window width',
})

-- Move lines and selections up and down.
map('i', '<A-j>', '<Esc>:move .+1<CR>==gi', {
  desc = 'Move line down',
})

map('i', '<A-k>', '<Esc>:move .-2<CR>==gi', {
  desc = 'Move line up',
})

map('n', '<A-j>', '<cmd>move .+1<CR>==', {
  desc = 'Move line down',
})

map('n', '<A-k>', '<cmd>move .-2<CR>==', {
  desc = 'Move line up',
})

map('x', '<A-j>', ":move '>+1<CR>gv=gv", {
  desc = 'Move selection down',
})

map('x', '<A-k>', ":move '<-2<CR>gv=gv", {
  desc = 'Move selection up',
})
