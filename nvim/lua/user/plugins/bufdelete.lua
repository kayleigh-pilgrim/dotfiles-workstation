-- Close buffers without closing the split window.
local function delete_all_buffers()
  local bufremove = require('mini.bufremove')
  local buffers = vim.fn.getbufinfo({
    buflisted = 1,
  })

  for _, buffer in ipairs(buffers) do
    local deleted = bufremove.delete(buffer.bufnr, false)

    if not deleted then
      return
    end
  end
end

return {
  'nvim-mini/mini.bufremove',
  version = '*',

  keys = {
    {
      '<leader>q',
      function()
        require('mini.bufremove').delete(0, false)
      end,
      desc = 'Delete current buffer',
    },
    {
      '<leader>Q',
      delete_all_buffers,
      desc = 'Delete all buffers',
    },
  },
}
