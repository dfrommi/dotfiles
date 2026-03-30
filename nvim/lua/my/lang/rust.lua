local file_info = require("my.utils.file_info")
if not file_info.root_has_file("Cargo.toml") then
  return {}
end

local M = {}

local code = require("my.code")
code.treesitter("rust")
code.mason("codelldb")
code.conform("rust", "rustfmt")
code.test_adapter(require("rustaceanvim.neotest"))

-- enabled by rustaceanvim
vim.lsp.config("rust-analyzer", {
  on_attach = function(client, bufnr)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    local function rlsp(sub)
      return function()
        vim.cmd.RustLsp(sub)
      end
    end

    require("my.keymap").rust_bindings(map, rlsp)
  end,
})

require("crates").setup({
  lsp = {
    enabled = true,
    -- on_attach = function(client, bufnr)
    --     -- the same on_attach function as for your other language servers
    --     -- can be ommited if you're using the `LspAttach` autocmd
    -- end,
    actions = true,
    completion = true,
    hover = true,
  },
  completion = {
    crates = {
      enabled = true, -- Disabled by default
      max_results = 8, -- The maximum number of search results to display
      min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
    },
  },
})

return M
