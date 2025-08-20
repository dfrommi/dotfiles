require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = { -- disable built-ins; binding manually
      accept = false,
      accept_word = false,
      accept_line = false,
      next = false,
      prev = false,
      dismiss = false,
    },
  },
  panel = { enabled = false },

  server_opts_overrides = {
    settings = {
      -- disable for now because of partial accept. Needs manual setting of range after confirmation
      telemetry = {
        telemetryLevel = "off",
      },
    },
  },
})

local cop = require("copilot.suggestion")

local M = {}

function M.is_visible()
  return cop.is_visible()
end

function M.show()
  cop.next()
end

function M.has_next()
  return cop.has_next()
end

function M.next()
  cop.next()
end

function M.dismiss()
  cop.dismiss()
end

function M.accept()
  cop.accept()
end

return M
