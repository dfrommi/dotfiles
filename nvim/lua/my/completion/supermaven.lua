local enabled = true

local binary = require("supermaven-nvim.binary.binary_handler")

require("supermaven-nvim").setup({
  disable_keymaps = true,
})

local completion_preview = require("supermaven-nvim.completion_preview")

local M = {}

function M.is_visible()
  return enabled or completion_preview.has_suggestion()
end

function M.show()
  enabled = true

  local buffer = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  binary:provide_inline_completion_items(buffer, cursor, binary.last_context)
end

function M.has_next()
  return false
end

function M.next()
  --nothing to do. Only single suggestion is available
end

function M.dismiss()
  completion_preview.on_dispose_inlay()
  enabled = false
end

function M.accept()
  -- without scheduping, an error is thrown
  -- E565: Not allowed to change text or change window
  vim.schedule(function()
    completion_preview.on_accept_suggestion()
  end)
end

return M
