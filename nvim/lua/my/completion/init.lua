local function feed(keys, mode)
  if not mode then
    mode = vim.fn.mode() -- default to current mode
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode, false)
end

-- accept all and set marks s and t at start and end of suggestion
local function accept_with_marks(accept, and_then)
  local buf = 0 -- current buffer
  local row_s, col_s = unpack(vim.api.nvim_win_get_cursor(buf))

  -- accept active AI suggestion
  accept()

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

local M = {}

function M.start_interactive()
  -- go to mark s and start visual mode with first word selected
  -- requires feed instead of vim.cmd to really enter visual mode
  feed("<esc>`svw", "n")
end

-- assumes suggestion is between marks s and t
function M.apply_interactive()
  -- multiple norm commands to make sure cursor position is correct
  vim.cmd([[ norm! "sy ]]) -- yank selection (to keep) into register s
  vim.cmd([[ norm! `sv`t ]]) -- select suggestion region
  vim.cmd([[ norm! "sp ]]) -- replace full range with selection from register s
  vim.cmd([[ norm! `]mta ]]) -- jump to end, fix mark t and go back to insert mode
end

-- function M.action(pum_action, copilot_action, fallback_key)
--   return function()
--     if pum_visible() and pum_action then
--       return (pum_action() or fallback_key or "")
--     elseif cop.is_visible() and copilot_action then
--       return (copilot_action() or fallback_key or "")
--     end
--
--     return fallback_key or ""
--   end
-- end

local pum = require("my.completion.pum")
local cop = require("my.completion.copilot")

function M.cycle()
  if pum.is_visible() then
    pum.dismiss()
    cop.show()
    return true
  elseif cop.is_visible() then
    if cop.has_next() then
      cop.next()
    else
      cop.dismiss()
      pum.show()
    end
    return true
  else
    -- stuck when no next item and pum not visible because no completion available
    cop.show()
    return true
  end
end

function M.accept()
  if pum.is_visible() then
    pum.accept()
    return true
  elseif cop.is_visible() then
    accept_with_marks(cop.accept)
    return true
  end
end

function M.accept_interactive()
  if pum.is_visible() then
    pum.accept() -- no interactive supported
    return true
  elseif cop.is_visible() then
    accept_with_marks(cop.accept, M.start_interactive)
    return true
  end
end

function M.dismiss()
  if pum.is_visible() then
    pum.dismiss()
    return true
  elseif cop.is_visible() then
    cop.dismiss()
    return true
  end
end

-- to fix weird CR behavior when popup menu selection is accepted with CR
function M.pum_accept_if_selected()
  if pum.is_visible() then
    return pum.accept_if_selected()
  end
end

return M
