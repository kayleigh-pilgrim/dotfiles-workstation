-- Smooth scrolling for half-page and full-page movements.
local function scroll(method, duration)
  return function()
    require('neoscroll')[method]({
      duration = duration,
    })
  end
end

return {
  'karb94/neoscroll.nvim',

  opts = {
    -- Define mappings through Lazy below instead of installing all
    -- of Neoscroll's default mappings.
    mappings = {},

    easing = 'sine',
    respect_scrolloff = true,
  },

  keys = {
    {
      '<C-u>',
      scroll('ctrl_u', 100),
      mode = {
        'n',
        'x',
      },
      desc = 'Smooth half-page up',
    },
    {
      '<C-d>',
      scroll('ctrl_d', 100),
      mode = {
        'n',
        'x',
      },
      desc = 'Smooth half-page down',
    },
    {
      '<C-b>',
      scroll('ctrl_b', 250),
      mode = {
        'n',
        'x',
      },
      desc = 'Smooth page up',
    },
    {
      '<C-f>',
      scroll('ctrl_f', 250),
      mode = {
        'n',
        'x',
      },
      desc = 'Smooth page down',
    },
  },
}
