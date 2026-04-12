local M = {}

local function current_file_path()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    return nil
  end
  return file_path
end

local function current_dir_path()
  local dir_path = vim.fn.expand("%:p:h")
  if dir_path == "" then
    return nil
  end
  return dir_path
end

local function project_root(file_path)
  if not file_path then
    return vim.fn.getcwd()
  end
  return vim.fs.root(file_path, { ".git" }) or vim.fn.getcwd()
end

local function relative_to_root(path, root)
  local relative = vim.fs.relpath(root, path)
  if relative and relative ~= "" then
    return relative
  end
  return path
end

local function get_lsp_call_hierarchy_item()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if not clients or #clients == 0 then
    return nil, nil
  end

  local params = vim.lsp.util.make_position_params()

  local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/prepareCallHierarchy", params, 500)

  if not responses then
    return nil, nil
  end

  for client_id, resp in pairs(responses) do
    local item = resp.result and resp.result[1]
    if item then
      local client = vim.lsp.get_client_by_id(client_id)
      return item, client
    end
  end

  return nil, nil
end

local function class_from_uri(uri, class_name)
  if not uri or not class_name then
    return nil
  end

  -- strip "file://"
  local path = uri:gsub("^file://", "")

  -- extract after /java/
  local pkg_path = path:match("/java/(.+)/[^/]+%.java$")
  if not pkg_path then
    return nil
  end

  local pkg = pkg_path:gsub("/", ".")
  return pkg .. "." .. class_name
end

function M.relative_file_path()
  local file_path = current_file_path()
  if not file_path then
    return nil
  end
  return relative_to_root(file_path, project_root(file_path))
end

function M.relative_dir_path()
  local file_path = current_file_path()
  local dir_path = current_dir_path()
  if not file_path or not dir_path then
    return nil
  end
  return relative_to_root(dir_path, project_root(file_path))
end

function M.selection_line_range()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  return start_line, end_line
end

function M.lsp_symbol()
  local item, client = get_lsp_call_hierarchy_item()
  if not item or not client then
    return nil
  end

  local name = item.name or ""
  local detail = item.detail or ""

  -- Java formatting
  if client.name == "jdtls" then
    local method = name:gsub("%b()", ""):gsub("%s*:.*$", "")

    if detail ~= "" then
      if method ~= "" and method ~= name then
        return detail .. "#" .. method
      else
        return detail .. "." .. name
      end
    end

    -- fallback for top-level class
    local class_fqn = class_from_uri(item.uri, name)

    if class_fqn then
      return class_fqn
    end

    return method
  else
    -- generic fallback
    if detail ~= "" and name ~= "" then
      return detail .. "." .. name
    end
    return name ~= "" and name or detail
  end
end

local function yank_text(value)
  if not value then
    vim.notify("No file path for current buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('"', value)
  vim.fn.setreg("+", value)
  vim.notify("Yanked: " .. value)
end

function M.yank_relative_file_path()
  yank_text(M.relative_file_path())
end

function M.yank_relative_file_path_with_range()
  local file_path = M.relative_file_path()
  if not file_path then
    yank_text(nil)
    return
  end
  local start_line, end_line = M.selection_line_range()
  yank_text(string.format("%s:%d-%d", file_path, start_line, end_line))
end

function M.yank_relative_dir_path()
  yank_text(M.relative_dir_path())
end

function M.yank_lsp_symbol()
  local symbol = M.lsp_symbol()
  if not symbol then
    vim.notify("No LSP symbol for current position", vim.log.levels.WARN)
    return
  end
  yank_text(symbol)
end

-- TODO there is some vim built in function
function M.root_has_file(...)
  local root = vim.fn.getcwd()
  for _, name in ipairs({ ... }) do
    if vim.uv.fs_stat(root .. "/" .. name) then
      return true
    end
  end
  return false
end

return M
