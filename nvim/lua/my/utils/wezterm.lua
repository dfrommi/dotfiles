local M = {}

local function cli(cmd)
  --os.execute("wezterm cli " .. cmd)
  print("wezterm cli " .. cmd)
  return vim.fn.system("wezterm cli " .. cmd)
end

local function uri_path(uri)
  if not uri or uri == vim.NIL then
    return ""
  end
  -- strip "file://<host>"
  return uri:gsub("^file://[^/]*", "")
end

local function endswith(s, suf)
  return s:sub(-#suf) == suf
end

-- getting frontmost process would be better, but wezterm cli does not expose it
function M.find_panes(title_pat, dir)
  local dir_abs = dir and vim.fn.expand(dir) or nil

  local out = cli("list --format json")
  if vim.v.shell_error ~= 0 or not out or out == "" then
    return nil, "failed to run wezterm cli list"
  end

  local ok, items = pcall(vim.json.decode, out)
  if not ok or type(items) ~= "table" then
    return nil, "bad json from wezterm"
  end

  local matches = {}
  local title_pat_l = title_pat:lower()
  for _, it in ipairs(items) do
    local title = tostring(it.title or ""):lower()
    if title:find(title_pat_l, 1, true) then
      if not dir_abs then
        table.insert(matches, it.pane_id)
      else
        local cwd = uri_path(it.cwd)
        if cwd ~= "" and endswith(cwd, dir_abs) then
          table.insert(matches, it.pane_id)
        end
      end
    end
  end

  return matches, nil
end

function M.find_pane_single(title_pat, dir)
  local matches, err = M.find_panes(title_pat, dir)

  if err then
    return nil, err
  end

  if not matches or #matches == 0 then
    return nil, "no match"
  elseif #matches == 1 then
    return matches[1], nil
  else
    return nil, "multiple matches: " .. table.concat(matches, ", ")
  end
end

function M.send_text(pane_id, text)
  cli(string.format([[send-text --pane-id %d %q]], pane_id, text))
end

function M.send_return_key(pane_id)
  -- very tricky to actually send a return key with auto-escaping on all ends
  -- needs os.execute to work, but maybe also because of the shell that is then used
  os.execute("wezterm cli send-text --no-paste --pane-id " .. pane_id .. " $'\r'")
end

function M.activate_pane(pane_id)
  cli(string.format([[activate-pane --pane-id %d]], pane_id))
end

-- direction can be "left", "right", "top", "bottom"
function M.split_with(pane_id, direction)
  local dir = direction or "right"
  cli(string.format([[split-pane --move-pane-id %d --%s]], pane_id, dir))
end

function M.unsplit(pane_id)
  cli(string.format([[move-pane-to-new-tab --pane-id %d]], pane_id))
end

function M.current_pane_id()
  return tonumber(os.getenv("WEZTERM_PANE"))
end

function M.shares_tab(pane_id_a, pane_id_b)
  local a = M.pane_info(pane_id_a)
  local b = M.pane_info(pane_id_b)
  return a ~= nil and b ~= nil and a.tab_id == b.tab_id
end

function M.kill_pane(pane_id)
  cli(string.format([[kill-pane --pane-id %d]], pane_id))
end

function M.pane_info(pane_id)
  local out = cli("list --format json")
  if vim.v.shell_error ~= 0 or not out or out == "" then
    return nil
  end

  local ok, items = pcall(vim.json.decode, out)
  if not ok or type(items) ~= "table" then
    return nil
  end

  for _, it in ipairs(items) do
    if it.pane_id == pane_id then
      return it
    end
  end
  return nil
end

-- Spawn a new split pane running prog_args with environment variables.
-- Returns the new pane_id or nil on failure.
function M.spawn_split(direction, percent, cwd, env, prog_args)
  local dir_flag = "--" .. (direction or "right")
  local parts = { "split-pane", dir_flag }

  if percent then
    table.insert(parts, "--percent")
    table.insert(parts, tostring(percent))
  end

  if cwd then
    table.insert(parts, "--cwd")
    table.insert(parts, cwd)
  end

  table.insert(parts, "--")

  -- Use env command to set environment variables
  if env and next(env) then
    table.insert(parts, "/usr/bin/env")
    for k, v in pairs(env) do
      table.insert(parts, k .. "=" .. v)
    end
  end

  for _, arg in ipairs(prog_args) do
    table.insert(parts, arg)
  end

  local out = cli(table.concat(parts, " "))
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return tonumber(vim.trim(out or ""))
end

return M
