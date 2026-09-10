local M = {}

local wez = require("my.utils.wezterm")
local file_info = require("my.utils.file_info")

local assistant_pane_id = nil
local nvim_pane_id = wez.current_pane_id()

local function is_alive()
  return assistant_pane_id ~= nil and wez.pane_info(assistant_pane_id) ~= nil
end

local function is_visible()
  return wez.shares_tab(assistant_pane_id, nvim_pane_id)
end

function M.toggle()
  if not is_alive() then
    assistant_pane_id = wez.spawn_split("right", 50, vim.fn.getcwd(), nil, { "copilot" })
    if not assistant_pane_id then
      vim.notify("Failed to spawn Copilot", vim.log.levels.ERROR)
      return
    end
    if nvim_pane_id then
      wez.activate_pane(nvim_pane_id)
    end
    return
  end

  if not is_visible() then
    wez.split_with(assistant_pane_id, "right")
    wez.activate_pane(assistant_pane_id)
    return
  end

  wez.unsplit(assistant_pane_id)
end

function M.activate()
  if not is_alive() then
    return
  end
  if not is_visible() then
    wez.split_with(assistant_pane_id, "right")
  end
  wez.activate_pane(assistant_pane_id)
end

function M.close()
  if is_alive() then
    wez.kill_pane(assistant_pane_id)
  end
  assistant_pane_id = nil
end

local function send(text)
  if not is_alive() then
    vim.notify("Copilot pane not open", vim.log.levels.WARN)
    return false
  end
  wez.send_text(assistant_pane_id, text)
  return true
end

local function send_and_focus(text)
  if send(text) and is_visible() then
    wez.activate_pane(assistant_pane_id)
  end
end

function M.send_file_path()
  send_and_focus("@" .. file_info.relative_file_path() .. " ")
end

function M.send_file_path_with_range()
  local path = file_info.relative_file_path()
  local start_line, end_line = file_info.selection_line_range()
  send_and_focus(string.format("@%s:%d-%d ", path, start_line, end_line))
end

function M.send_dir_path()
  send_and_focus("@" .. file_info.relative_dir_path() .. " ")
end

function M.send_lsp_symbol()
  local symbol = file_info.lsp_symbol()
  if not symbol then
    vim.notify("No LSP symbol at cursor", vim.log.levels.WARN)
    return
  end
  send_and_focus(symbol .. " ")
end

local function find_copilot_in_current_tab()
  local panes, err = wez.find_panes("copilot")
  if not panes or err then
    return nil
  end
  for _, pane_id in ipairs(panes) do
    if pane_id ~= nvim_pane_id and wez.shares_tab(pane_id, nvim_pane_id) then
      return pane_id
    end
  end
  return nil
end

function M.setup()
  local keymap = require("my.keymap")
  require("sidekick").setup()
  keymap.sidekick_nes_bindings()
  keymap.assistant_bindings(M)

  if nvim_pane_id then
    local existing = find_copilot_in_current_tab()
    if existing then
      assistant_pane_id = existing
    end
  end
end

return M
