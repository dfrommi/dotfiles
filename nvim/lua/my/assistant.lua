local oc = require("opencode")

local M = {}

local wezterm = require("my.utils.wezterm")

local function find_codex()
  local pane_id, err = wezterm.find_pane_single("codex", vim.fn.getcwd())

  if err then
    print("404 Codex not found: " .. err)
    return
  end

  return pane_id
end

local function with_codex(fn)
  local pane_id = find_codex()

  if not pane_id then
    print("404 Codex not found")
    return false
  end

  fn(pane_id)
  return true
end

-- intercepting opencode communication, used by the other methods
function oc.prompt(prompt)
  -- process input, replace placeholders like @selection
  prompt = require("opencode.context").inject(prompt)

  local executed = with_codex(function(pane_id)
    wezterm.send_text(pane_id, prompt)
    wezterm.send_return_key(pane_id)
  end)

  if not executed then
    vim.fn.setreg("+", prompt)
  end
end

function M.ask(default, opts)
  return function()
    oc.ask(default, opts)
  end
end

function M.select_prompt()
  return oc.select()
end

function M.activate()
  with_codex(function(pane_id)
    wezterm.activate_pane(pane_id)
  end)
end

function M.split_right()
  with_codex(function(pane_id)
    wezterm.split_with(pane_id, "right")
  end)
end

function M.split_bottom()
  with_codex(function(pane_id)
    wezterm.split_with(pane_id, "bottom")
  end)
end

function M.unsplit()
  with_codex(function(pane_id)
    wezterm.unsplit(pane_id)
  end)
end

return M
