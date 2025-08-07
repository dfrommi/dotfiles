-- Interesting examples:
--   https://github.com/m:qqqplusp/nvim-0.12-vim-pack-intro
--   https://gpanders.com/blog/whats-new-in-neovim-0-11/#lspa
--   https://github.com/SylvanFranklin/.config/blob/main/nvim/init.lua

-- TODO:
--   - missing keybindings:
--     - other buffer navigation
--     - window split
--     - window jumps
--   - window navigation
--   - Wezterm window navigation

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
  "https://github.com/folke/which-key.nvim", -- keybinding help
  "https://github.com/folke/snacks.nvim",    -- item picker popup
  "https://github.com/folke/flash.nvim",     -- jump around
  "https://github.com/echasnovski/mini.ai",  -- text objects and surrounding text manipulation
  -- "https://github.com/HiPhish/rainbow-delimiters.nvim", -- rainbow brackets

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
  "https://github.com/mrjones2014/smart-splits.nvim", -- integrate with wezterm splits

  --
  -- AI
  --
  "https://github.com/zbirenbaum/copilot.lua",         -- suggestions
  "https://github.com/CopilotC-Nvim/CopilotChat.nvim", -- chat interface

  --
  -- DEPENDENCIES
  --
  "https://github.com/nvim-lua/plenary.nvim", -- common dependency (e.g. CopilotChat)
})

local picker = require("snacks").picker
local flash = require("flash")
local chat = require("CopilotChat")
local splits = require("smart-splits")

--
-- CORE
--
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>P", [["+P]], { desc = "Paste before from system clipboard" })

-- Colemak fix for jumplist
vim.keymap.set("n", "<C-i>", "<C-o>", { desc = "Jump back (Colemak)" })
vim.keymap.set("n", "<C-o>", "<C-i>", { desc = "Jump forward (Colemak)" })

--
-- ITEM PICKER
--

-- Global
vim.keymap.set("n", "<leader>fR", picker.resume, { desc = "Resume" })
vim.keymap.set("n", "<leader><space>", picker.grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>ff", picker.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fb", picker.buffers, { desc = "Buffers" })
--vim.keymap.set("n", "<leader>fr", picker.recent, { desc = "Recent" })
vim.keymap.set("n", "<leader>fe", picker.explorer, { desc = "File Explorer" })
-- vim.keymap.set("n", "<leader>fg", picker.git_files, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fh", picker.help, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>fk", picker.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fs", picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set({ "n", "x" }, "<leader>*", picker.grep_word, { desc = "Visual selection or word" })

-- in buffer
vim.keymap.set("n", "<leader>/", picker.lines, { desc = "Buffer Lines" })
-- vim.keymap.set("n", "<leader>sB", picker.grep_buffers, { desc = "Grep Open Buffers" })

-- LSP
vim.keymap.set("n", "gs", picker.lsp_symbols, { desc = "Goto Symbol" })
vim.keymap.set("n", "gd", picker.lsp_definitions, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", picker.lsp_declarations, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", picker.lsp_references, { nowait = true, desc = "References" })
vim.keymap.set("n", "gI", picker.lsp_implementations, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

--
-- CODE EDITING
--
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cA", function() -- run code actions only on the source (e.g. fix imports)
  vim.lsp.buf.code_action({
    context = { only = { "source" }, },
  })
end, { desc = "Code Actions" })

--
-- JUMPING
--
vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", flash.remote, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter Search" })

--
-- WINDOW MANAGEMENT
--
vim.keymap.set("n", "<leader><tab>", ":e #<CR>", { desc = "Toggle Buffer" })
-- CTRL+W S/V to create splits
vim.keymap.set('n', '<C-h>', splits.move_cursor_left, { desc = "Go to Left Window" })
vim.keymap.set('n', '<C-j>', splits.move_cursor_down, { desc = "Go to Bottom Window" })
vim.keymap.set('n', '<C-k>', splits.move_cursor_up, { desc = "Go to Top Window" })
vim.keymap.set('n', '<C-l>', splits.move_cursor_right, { desc = "Go to Right Window" })
vim.keymap.set('n', '<A-h>', splits.resize_left, { desc = "Shrink Window Horizontally" })
vim.keymap.set('n', '<A-j>', splits.resize_down, { desc = "Shrink Window Vertically" })
vim.keymap.set('n', '<A-k>', splits.resize_up, { desc = "Grow Window Vertically" })
vim.keymap.set('n', '<A-l>', splits.resize_right, { desc = "Grow Window Horizontally" })
--vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

--
-- AI
--
vim.keymap.set({ "n", "v" }, "<leader>aa", chat.toggle, { desc = "Toggle (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader>ap", chat.select_prompt, { desc = "Prompt Actions (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader>ax", chat.reset, { desc = "Clear (CopilotChat)" })

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

require("which-key").setup({
  preset = "helix",
  show_help = false
})

require("snacks").setup({
  picker = {},   -- enable picker
  explorer = {} -- enable explorer
})

require("mini.ai").setup()
-- require("rainbow-delimiters.setup").setup()

require("smart-splits").setup({})

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
