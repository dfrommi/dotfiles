-- Interesting examples:
--   https://github.com/m:qqqplusp/nvim-0.12-vim-pack-intro
--   https://gpanders.com/blog/whats-new-in-neovim-0-11/#lspa
--   https://github.com/SylvanFranklin/.config/blob/main/nvim/init.lua

-- TODO:
--   - migrate key mappings back to plain vim keymaps
--   - check flash.nvim for more options
--   - add mini.ai
--   - configure more code keymaps (like ca)
--   - look into built-in keymaps for LSP

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true


-- OS integration
vim.opt.mouse = "a"
vim.opt.clipboard = "" -- don't interfere with system clipboard

-- General
vim.opt.undofile = true
vim.opt.swapfile = false

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.winborder = 'rounded' -- Set the default border for all floating windows
vim.opt.termguicolors = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Preview substitutions
-- vim.opt.inccommand = 'split'

-- Text wrapping
vim.opt.wrap = true
vim.opt.breakindent = true

-- Tabstops
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Completion
vim.opt.completeopt = "menu,menuone,noselect" -- show menu also when only one match, don't select automatically
vim.opt.pumheight = 10                        -- max lines in popup menu

vim.pack.add({
  --
  -- CORE
  --
  "https://github.com/folke/which-key.nvim",  -- keybinding help
  "https://github.com/folke/snacks.nvim",     -- item picker popup
  "https://github.com/folke/flash.nvim",      -- jump around
  "https://github.com/nvim-lua/plenary.nvim", -- common dependency

  --
  -- LSP
  --
  "https://github.com/neovim/nvim-lspconfig", -- configures LSP servers
  "https://github.com/mrcjkb/rustaceanvim",   -- Rust LSP with additional features

  --
  -- TREESITTER
  --
  "https://github.com/nvim-treesitter/nvim-treesitter",         -- syntax highlighter
  "https://github.com/nvim-treesitter/nvim-treesitter-context", -- show surrounding context on top of editor

  --
  -- CODING TOOLS
  --
  "https://github.com/lewis6991/gitsigns.nvim", -- show git changes in the gutter

  --
  -- UI
  --
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin"
  },
  "https://github.com/nvim-lualine/lualine.nvim",   -- nice looking status line at the bottom
  "https://github.com/nvim-tree/nvim-web-devicons", -- dependency of lualine

  --
  -- AI
  --
  "https://github.com/zbirenbaum/copilot.lua",        -- suggestions
  "https://github.com/CopilotC-Nvim/CopilotChat.nvim" -- chat interface
})

local keys = require("which-key")
local picker = require("snacks").picker
local flash = require("flash")
local chat = require("CopilotChat")

keys.add({
  --
  -- CORE
  --
  { "p",               [["_dP]],                     mode = "x",                            desc = "Paste without yanking" },
  { "<leader>d",       [["_d]],                      mode = { "n", "v" },                   desc = "Delete without yanking" },

  { "<leader>y",       [["+y]],                      mode = { "n", "v" },                   desc = "Yank to system clipboard" },
  { "<leader>Y",       [["+Y]],                      desc = "Yank line to system clipboard" },
  { "<leader>p",       [["+p]],                      mode = { "n", "x" },                   desc = "Paste from system clipboard" },
  { "<leader>P",       [["+P]],                      mode = { "n", "x" },                   desc = "Paste before from system clipboard" },

  -- Colemak fix for jumplist
  { "<C-i>",           "<C-o>",                      mode = "n",                            desc = "Jump back (Colemak)" },
  { "<C-o>",           "<C-i>",                      mode = "n",                            desc = "Jump forward (Colemak)" },

  --
  -- ITEM PICKER
  --
  { "<leader>fR",      picker.resume,                desc = "Resume" },
  { "<leader><space>", picker.smart,                 desc = "Smart Find Files" },
  { "<leader>/",       picker.grep,                  desc = "Grep" },
  { "<leader>fb",      picker.buffers,               desc = "Buffers" },
  { "<leader>fr",      picker.recent,                desc = "Recent" },
  { "<leader>fe",      picker.explorer,              desc = "File Explorer" },
  { "<leader>ff",      picker.files,                 desc = "Find Files" },
  -- { "<leader>fg", picker.git_files, desc = "Find Git Files" },
  { "<leader>fh",      picker.help,                  desc = "Help Pages" },

  { "<leader>sb",      picker.lines,                 desc = "Buffer Lines" },
  { "<leader>sB",      picker.grep_buffers,          desc = "Grep Open Buffers" },
  -- { "<leader>sw", picker.grep_word, desc = "Visual selection or word", mode = { "n", "x" } },

  -- LSP
  -- TODO look into neovim default mappings
  { "gd",              picker.lsp_definitions,       desc = "Goto Definition" },
  { "gD",              picker.lsp_declarations,      desc = "Goto Declaration" },
  { "gr",              picker.lsp_references,        nowait = true,                         desc = "References" },
  { "gI",              picker.lsp_implementations,   desc = "Goto Implementation" },
  { "gy",              picker.lsp_type_definitions,  desc = "Goto T[y]pe Definition" },
  { "<leader>ss",      picker.lsp_symbols,           desc = "LSP Symbols" },
  { "<leader>sS",      picker.lsp_workspace_symbols, desc = "LSP Workspace Symbols" },

  --
  -- CODE EDITING
  --
  { "<leader>cf",      vim.lsp.buf.format,           desc = "Format buffer" },

  --
  -- JUMPING
  --
  { "s",               mode = { "n", "x", "o" },     flash.jump,                            desc = "Flash" },
  { "S",               mode = { "n", "x", "o" },     flash.treesitter,                      desc = "Flash Treesitter" },
  { "r",               mode = "o",                   flash.remote,                          desc = "Remote Flash" },
  { "R",               mode = { "o", "x" },          flash.treesitter_search,               desc = "Treesitter Search" },

  --
  -- AI
  --
  { "<leader>a",       "",                           desc = "+ai",                          mode = { "n", "v" } },
  { "<leader>aa",      chat.toggle,                  desc = "Toggle (CopilotChat)",         mode = { "n", "v" }, },
  { "<leader>ap",      chat.select_prompt,           desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" }, },
  { "<leader>ax",      chat.reset,                   desc = "Clear (CopilotChat)",          mode = { "n", "v" }, },
})

require("gitsigns").setup({
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end

    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghd", gs.preview_hunk_inline, "Diff Hunk Inline")
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  end,
})

keys.setup({
  preset = "helix",
  show_help = false
})

require("snacks").setup({
  picker = {},  -- enable picker
  explorer = {} -- enable explorer
})

--
-- LSP
--
-- LSP is the “language server” — it understands code semantics and helps with editing and refactoring.
-- no Mason, install LSPs manually with homebrew
-- debug with :LspInfo
vim.lsp.enable({ "lua_ls" })

vim.diagnostic.config({
  -- show diagnostic on extra lines
  virtual_text = true,
  -- only on current line
  virtual_lines = {
    current_line = true,
  },
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
})

-- enable built-in completion if LSP supports it
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

--
-- TREESITTER
--
-- Treesitter is the “syntax tree parser” — it understands code structure and helps with navigation, highlighting, and text manipulation.
-- syntax highlighting. Update with :TSUpdate and install new with :TSInstall or add to list
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'lua',
    'vimdoc',
    'vim',
    'bash',
    'fish',
    'rust',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false -- for Catpucchin
  },
  indent = { enable = true },
})

--
-- STYLE
--
require('lualine').setup()
vim.cmd.colorscheme("catppuccin-mocha")

--
-- AI
--
require('copilot').setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<tab>",
      accept_word = "<S-tab>",
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      --dismiss = "<C-]>",
    },
  }
})

require("CopilotChat").setup()

-- clean up CopilotChat buffer
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-chat",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})
