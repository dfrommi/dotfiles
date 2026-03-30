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
  local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  return start_line, end_line
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
