local keymap = require("my.keymap")

require("lualine").setup()
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
