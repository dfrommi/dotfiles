local Config = require("sidekick.config")
local wezterm = require("my.utils.wezterm")

---@class adapter.sidekick.Wezterm: sidekick.cli.Session
---@field wezterm_pane_id integer
local M = {}
M.__index = M
M.priority = 50
M.external = true

-- Track spawned panes (not persisted across restarts)
---@type table<string, {pane_id: integer, tool: string, cwd: string}>
local panes = {}

local function split_direction()
  return Config.cli.mux.split.vertical and "right" or "bottom"
end

function M:start()
  -- Reuse existing pane if still alive
  local existing = panes[self.sid]
  if existing and wezterm.pane_info(existing.pane_id) then
    self.wezterm_pane_id = existing.pane_id
    self.id = "wezterm:" .. existing.pane_id
    self.started = true
    wezterm.split_with(existing.pane_id, split_direction())
    return
  end

  local split = Config.cli.mux.split
  local size = split.size
  local percent = size <= 1 and math.floor(size * 100) or size

  local pane_id = wezterm.spawn_split(split_direction(), percent, self.cwd, self.tool.env, self.tool.cmd)
  if not pane_id then
    return
  end

  panes[self.sid] = { pane_id = pane_id, tool = self.tool.name, cwd = self.cwd }
  self.wezterm_pane_id = pane_id
  self.id = "wezterm:" .. pane_id
  self.started = true
end

function M:attach()
  if self.wezterm_pane_id then
    wezterm.split_with(self.wezterm_pane_id, split_direction())
  end
end

function M:detach()
  if self.wezterm_pane_id then
    pcall(wezterm.unsplit, self.wezterm_pane_id)
  end
end

function M:send(text)
  if self.wezterm_pane_id then
    wezterm.send_text(self.wezterm_pane_id, text)
  end
end

function M:submit()
  if self.wezterm_pane_id then
    wezterm.send_return_key(self.wezterm_pane_id)
  end
end

function M:is_running()
  if not self.wezterm_pane_id then
    return false
  end
  return wezterm.pane_info(self.wezterm_pane_id) ~= nil
end

function M:dump()
  if not self.wezterm_pane_id then
    return
  end
  return wezterm.get_text(self.wezterm_pane_id)
end

function M.sessions()
  local ret = {} ---@type sidekick.cli.session.State[]
  for sid, info in pairs(panes) do
    if wezterm.pane_info(info.pane_id) then
      ret[#ret + 1] = {
        id = "wezterm:" .. info.pane_id,
        cwd = info.cwd,
        tool = info.tool,
        wezterm_pane_id = info.pane_id,
      }
    else
      panes[sid] = nil
    end
  end
  return ret
end

function M.kill()
  for sid, info in pairs(panes) do
    pcall(wezterm.kill_pane, info.pane_id)
    panes[sid] = nil
  end
end

return M
