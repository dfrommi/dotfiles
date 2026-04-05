local wez = require("my.utils.wezterm")

-- WezTerm terminal provider for claudecode.nvim
-- Runs Claude Code in a native WezTerm split pane instead of an embedded Neovim terminal.

local pane_id = nil
local nvim_pane_id = wez.current_pane_id()

local function is_alive()
  return wez.pane_info(pane_id) ~= nil
end

local function is_visible()
  return wez.shares_tab(pane_id, nvim_pane_id)
end

local function cleanup()
  pane_id = nil
end

local function split_percent(config)
  local pct = config and config.window and config.split_ratio
  if pct and pct > 0 and pct < 1 then
    return math.floor(pct * 100)
  end
  return 50
end

local function split_direction(config)
  if config and config.split_side == "left" then
    return "left"
  end
  return "right"
end

local provider = {}

function provider.setup(_config) end

local function spawn_claude(cmd_string, env_table, config, focus)
  local prog_args = {}
  for arg in cmd_string:gmatch("%S+") do
    table.insert(prog_args, arg)
  end

  local new_id =
    wez.spawn_split(split_direction(config), split_percent(config), config and config.cwd, env_table, prog_args)

  if not new_id then
    vim.notify("Failed to spawn Claude in WezTerm pane", vim.log.levels.ERROR)
    return
  end

  pane_id = new_id

  if not focus and nvim_pane_id then
    wez.activate_pane(nvim_pane_id)
  end
end

function provider.open(cmd_string, env_table, config, focus)
  if focus == nil then
    focus = true
  end

  if is_alive() then
    if not is_visible() then
      wez.split_with(pane_id, split_direction(config))
    end
    if focus then
      wez.activate_pane(pane_id)
    end
    return
  end

  spawn_claude(cmd_string, env_table, config, focus)
end

function provider.close()
  if is_alive() then
    wez.kill_pane(pane_id)
  end
  cleanup()
end

function provider.simple_toggle(cmd_string, env_table, config)
  if not is_alive() then
    spawn_claude(cmd_string, env_table, config, true)
    return
  end

  if is_visible() then
    wez.unsplit(pane_id)
  else
    wez.split_with(pane_id, split_direction(config))
  end
end

function provider.focus_toggle(cmd_string, env_table, config)
  if not is_alive() then
    spawn_claude(cmd_string, env_table, config, true)
    return
  end

  if not is_visible() then
    wez.split_with(pane_id, split_direction(config))
    wez.activate_pane(pane_id)
    return
  end

  -- Visible — if called from Neovim, Neovim has focus → go to Claude
  wez.activate_pane(pane_id)
end

function provider.get_active_bufnr()
  return nil
end

function provider.is_available()
  return true
end

function provider._get_terminal_for_test()
  return pane_id and { pane_id = pane_id } or nil
end

return provider
