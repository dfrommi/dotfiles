local M = {}

local picker = require("snacks").picker
local mini_files = require("mini.files")

function M.explorer()
  mini_files.open()
end

function M.explorer_in_buffer_dir()
  mini_files.open(vim.api.nvim_buf_get_name(0))
end

function M.files()
  picker.files()
end

function M.files_in_buffer_dir()
  picker.files({
    dirs = { vim.fn.expand("%:h") },
  })
end

function M.grep()
  picker.grep()
end

function M.grep_in_buffer_dir()
  picker.grep({
    dirs = { vim.fn.expand("%:h") },
  })
end

function M.buffers()
  picker.buffers()
end

function M.grep_buffers()
  picker.grep_buffers()
end

function M.help()
  picker.help()
end

function M.keymaps()
  picker.keymaps()
end

function M.marks()
  picker.marks()
end

function M.grep_word()
  picker.grep_word()
end

---
--- LSP
---
local function is_main_symbol(item, ctx)
  if ctx.client.name == "jdtls" then
    return item.path and item.path:find("/src/main/", 1, true) ~= nil
  end

  if ctx.client.name == "rust-analyzer" then
    return item.path and item.path:find("/.cargo/", 1, true) == nil and item.path:find("/.rustup/", 1, true) == nil
  end

  return item.path ~= nil
end

function M.own_lsp_workspace_symbols()
  picker.lsp_workspace_symbols({
    transform = function(item)
      local path = item.file or item.filename or ""
      return path:find(vim.fn.getcwd(), 1, true) ~= nil
    end,
  })
end

function M.all_lsp_workspace_symbols()
  picker.lsp_workspace_symbols()
end

function M.buffer_lsp_symbols()
  picker.lsp_symbols({
    -- layout = { preset = "vscode" },
    layout = { preset = "select" },
    filter = {
      rust = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        -- "Module", -- all imports are shown as modules
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
      },
    },
    win = {
      input = {
        keys = {
          -- single ESC to jump out of the popup, no double-esc needed
          ["<Esc>"] = { "close", mode = { "n", "i" } },
        },
      },
    },
  })
end

function M.call_hierarchy_in()
  picker.call_hierarchy_in({
    lsp_filter = is_main_symbol,
  })
end

function M.call_hierarchy_in_ext()
  picker.call_hierarchy_in()
end

function M.call_hierarchy_out()
  picker.call_hierarchy_in({
    lsp_filter = is_main_symbol,
  })
end

function M.call_hierarchy_out_ext()
  picker.call_hierarchy_in()
end

return M
