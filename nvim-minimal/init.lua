-- Core Neovim options
local opt = vim.opt

-- General
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
-- opt.backup = false
-- opt.undofile = true
-- opt.undodir = vim.fn.stdpath("data") .. "/undo"
-- opt.updatetime = 250
-- opt.timeoutlen = 400

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
-- opt.scrolloff = 8
-- opt.sidescrolloff = 8
-- opt.colorcolumn = "80"
opt.termguicolors = true
opt.winborder = "rounded"

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Splits
-- opt.splitright = true
-- opt.splitbelow = true

-- Completion
-- show menu also when only one match, don't select automatically
opt.completeopt = "menu,menuone,noselect"
-- max lines in popup menu
opt.pumheight = 10

-- Folding (using treesitter)
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldenable = false

-- show diagnostic on extra lines
vim.diagnostic.config({
  virtual_text = true,
  -- only on current line
  virtual_lines = {
    current_line = true,
  },
})

vim.g.mapleader = " "

vim.pack.add({ 
  "https://github.com/echasnovski/mini.extra",
  "https://github.com/echasnovski/mini.pick",
})
require("mini.extra").setup()
require("mini.pick").setup()

-- LSP is the “language server” — it understands code semantics and helps with editing and refactoring.
-- Treesitter is the “syntax tree parser” — it understands code structure and helps with navigation, highlighting, and text manipulation.

--
-- LSP
--
-- no Mason, install LSPs manually with homebrew
vim.pack.add {
  "https://github.com/neovim/nvim-lspconfig",          -- configures LSP servers
  "https://github.com/mrcjkb/rustaceanvim" -- Rust LSP with additional features
  -- { src = 'https://github.com/mason-org/mason.nvim' },           -- installs LSP servers
  -- { src = 'https://github.com/mason-org/mason-lspconfig.nvim' }, -- connects mason.nvim and nvim-lspconfig
  --{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" } -- declarativley install mason packages
}

vim.lsp.enable({ "lua_ls" })

-- require('mason').setup()
-- require("mason-lspconfig").setup {
--     ensure_installed = { "lua_ls", "rust_analyzer" },
-- }
-- require("mason-tool-installer").setup({
--   ensure_installed = {
--     "lua-language-server",
--     "stylua",
--     "rust-analyzer",
--   },
--   auto_update = false,
--   run_on_start = true,
-- })

-- Support of vim objects
-- vim.lsp.config('lua_ls', {
--   settings = {
--     Lua = {
--       runtime = {
--         version = 'LuaJIT',
--       },
--       diagnostics = {
--         globals = {
--           'vim',
--           'require'
--         },
--       },
--       workspace = {
--         library = vim.api.nvim_get_runtime_file("", true),
--       },
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
vim.cmd("set completeopt+=noselect") -- TODO understand

--
-- TREESITTER
--
vim.pack.add {
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'vimdoc', 'vim' },
  highlight = { enable = true },
  indent = { enable = true },
})

--
-- STYLE
--
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim",            name = "catppuccin" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" }
})
require('lualine').setup()
vim.cmd.colorscheme("catppuccin-mocha")

--
-- KEYS
--
vim.keymap.set('n', '<leader>ff', ":Pick files<CR>")
vim.keymap.set('n', '<leader>f/', ":Pick live_grep<CR>")
vim.keymap.set('n', '<leader>fh', ":Pick help<CR>")

local pick = require("mini.extra").pickers

-- Workspace-wide symbol search
vim.keymap.set("n", "<leader>sS", function()
  pick.lsp({ scope = "workspace_symbol" })
end, { desc = "Search workspace symbols" })

-- Current-buffer (document) symbol search
vim.keymap.set("n", "<leader>ss", function()
  pick.lsp({ scope = "document_symbol" })
end, { desc = "Search document symbols" })


vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format)
