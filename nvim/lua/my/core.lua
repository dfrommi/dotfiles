local keymap = require("my.keymap")

local function buffer_parent_dir()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return nil
  end
  local parent = vim.fs.dirname(path) -- full parent path
  return parent and vim.fs.basename(parent) or nil -- just the last part
end

require("lualine").setup({
  sections = {
    -- replace branch with parent dir
    lualine_b = {
      {
        function()
          return buffer_parent_dir() or ""
        end,
        icon = "",
      },
    },
  },
})
vim.cmd.colorscheme("catppuccin-mocha")

require("which-key").setup({
  preset = "helix",
  show_help = false,
})

require("mini.ai").setup({
  n_lines = 500,
  custom_textobjects = keymap.mini_textobjects,
})

require("mini.surround").setup({
  mappings = keymap.mini_surround_mappings,
})

require("mini.files").setup({})

-- require("rainbow-delimiters.setup").setup()

require("smart-splits").setup({})

require("gitsigns").setup({
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end

    keymap.git_signs_bindings(map, gs)
  end,
})

local snacks = require("snacks")
snacks.setup({
  picker = {}, -- enable picker
  --explorer = {}, -- enable explorer
  indent = {},
})

local snacks_lsp_symbols = snacks.picker.lsp_symbols

snacks.picker.lsp_symbols = function(opts)
  return snacks_lsp_symbols({
    layout = {
      preset = "select",
    },
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
  })
end
