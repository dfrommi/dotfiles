vim.opt.completeopt = "menu,menuone,noselect" -- show menu also when only one match, don't select automatically
vim.opt.pumheight = 10 -- max lines in popup menu

-- enable built-in completion if LSP supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if not client then
      return
    end

    if client:supports_method("textDocument/completion") then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}
      -- for i = 32, 126 do
      --   table.insert(chars, string.char(i))
      -- end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      --vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end
  end,
})

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

local function feed(keys, mode)
  if not mode then
    mode = vim.fn.mode() -- default to current mode
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode, false)
end

-- accept all and set marks s and t at start and end of suggestion
local function copilot_accept(and_then)
  local buf = 0 -- current buffer
  local row_s, col_s = unpack(vim.api.nvim_win_get_cursor(buf))

  cop.accept()

  -- wait for next even loop to make sure accept is done
  -- otherwise the mark position will be at wrong place
  vim.schedule(function()
    -- s has to be set after accept, because it will change the mark position
    vim.api.nvim_buf_set_mark(buf, "s", row_s, col_s, {})

    local row_t, col_t = unpack(vim.api.nvim_win_get_cursor(buf))
    vim.api.nvim_buf_set_mark(buf, "t", row_t, col_t, {})

    if and_then then
      and_then()
    end
  end)
end

--
-- COMPLETION
--
local function pum_visible()
  return vim.fn.pumvisible() == 1
end

local function pum_selected()
  local info = vim.fn.complete_info({ "selected" })
  return info and info.selected >= 0 or false
end

local function copilot_start_keep_suggest()
  -- go to mark s and start visual mode with first word selected
  feed("<esc>`svw", "n")
end

-- assumes suggestion is between marks s and t
local function keep_suggest()
  -- multiple norm commands to make sure cursor position is correct
  vim.cmd([[ norm! "sy ]]) -- yank selection (to keep) into register s
  vim.cmd([[ norm! `sv`t ]]) -- select suggestion region
  vim.cmd([[ norm! "sp ]]) -- replace full range with selection from register s
  vim.cmd([[ norm! `]mta ]]) -- jump to end, fix mark t and go back to insert mode
end

local M = {
  pum = {},
  cop = {},
}

function M.action(pum_action, copilot_action, fallback_key)
  return function()
    if pum_visible() and pum_action then
      return (pum_action() or fallback_key or "")
    elseif cop.is_visible() and copilot_action then
      return (copilot_action() or fallback_key or "")
    end

    return fallback_key or ""
  end
end

function M.cycle(fallback_key)
  -- stuck when no next item and pum not visible because no completion available
  return function()
    if pum_visible() then
      return M.cop.show_or_next()
    elseif cop.is_visible() then
      if cop.has_next() then
        return M.cop.show_or_next()
      else
        return M.pum.show()
      end
    end

    return fallback_key or ""
  end
end

function M.pum.show()
  -- cover a corner case where no pum menu is visible because no completion is available
  if cop.is_visible() then
    cop.dismiss()
  end

  return "<C-x><C-o>"
end

function M.pum.confirm_selected_or_first()
  return M.pum.confirm_if_selected() or "<C-n><C-y>"
end

function M.pum.confirm_if_selected()
  if pum_selected() then
    return "<C-y>"
  end
end

function M.pum.dismiss()
  return "<C-e>"
end

function M.pum.next()
  return "<C-n>"
end

function M.pum.prev()
  return "<C-p>"
end

function M.cop.show_or_next()
  if pum_visible() then
    feed(M.pum.dismiss())
  end

  cop.next()
end

function M.cop.confirm_all_and_start_partial_accept()
  copilot_accept(copilot_start_keep_suggest)
end

function M.cop.confirm_selection()
  keep_suggest()
end

function M.cop.confirm_all()
  copilot_accept()
end

function M.cop.start_partial_accept()
  copilot_start_keep_suggest()
end

function M.cop.dismiss()
  cop.dismiss()
end

return M
