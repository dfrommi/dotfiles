local M = {}

---@param args string[]
---@param opts? vim.SystemOpts
---@return string?, string?
local function cli(args, opts)
  local cmd = { "wezterm", "cli" }
  vim.list_extend(cmd, args)
  local result = vim.system(cmd, vim.tbl_extend("force", { text = true }, opts or {})):wait()
  if result.code ~= 0 then
    return nil, vim.trim(result.stderr or "")
  end
  return result.stdout or "", nil
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

  local out, err = cli({ "list", "--format", "json" })
  if not out or out == "" then
    return nil, err or "failed to run wezterm cli list"
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
  cli({ "send-text", "--pane-id", tostring(pane_id) }, { stdin = text })
end

function M.send_return_key(pane_id)
  cli({ "send-text", "--no-paste", "--pane-id", tostring(pane_id) }, { stdin = "\r" })
end

function M.activate_pane(pane_id)
  cli({ "activate-pane", "--pane-id", tostring(pane_id) })
end

-- direction can be "left", "right", "top", "bottom"
function M.split_with(pane_id, direction)
  cli({ "split-pane", "--move-pane-id", tostring(pane_id), "--" .. (direction or "right") })
end

function M.unsplit(pane_id)
  cli({ "move-pane-to-new-tab", "--pane-id", tostring(pane_id) })
end

function M.get_text(pane_id)
  return cli({ "get-text", "--pane-id", tostring(pane_id) })
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
  cli({ "kill-pane", "--pane-id", tostring(pane_id) })
end

function M.pane_info(pane_id)
  local out, err = cli({ "list", "--format", "json" })
  if not out or out == "" then
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
  local args = { "split-pane", "--" .. (direction or "right") }

  if percent then
    table.insert(args, "--percent")
    table.insert(args, tostring(percent))
  end

  if cwd then
    table.insert(args, "--cwd")
    table.insert(args, cwd)
  end

  table.insert(args, "--")

  -- Use env command to set environment variables
  if env and next(env) then
    table.insert(args, "/usr/bin/env")
    for k, v in pairs(env) do
      table.insert(args, k .. "=" .. v)
    end
  end

  for _, arg in ipairs(prog_args) do
    table.insert(args, arg)
  end

  local out, err = cli(args)
  if not out then
    return nil
  end

  return tonumber(vim.trim(out))
end

return M
