-- Interesting examples:
--   https://github.com/m:qqqplusp/nvim-0.12-vim-pack-intro
--   https://gpanders.com/blog/whats-new-in-neovim-0-11/#lspa
--   https://github.com/SylvanFranklin/.config/blob/main/nvim/init.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.winborder = "rounded" -- Set the default border for all floating windows
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
vim.opt.pumheight = 10 -- max lines in popup menu

vim.pack.add({
  --
  -- CORE
  --
  "https://github.com/folke/which-key.nvim", -- keybinding help
  "https://github.com/folke/snacks.nvim", -- item picker popup
  "https://github.com/folke/flash.nvim", -- jump around
  "https://github.com/echasnovski/mini.ai", -- text objects and surrounding text manipulation
  -- "https://github.com/HiPhish/rainbow-delimiters.nvim", -- rainbow brackets

  --
  -- LSP
  --
  "https://github.com/neovim/nvim-lspconfig", -- configures LSP servers
  "https://github.com/mrcjkb/rustaceanvim", -- Rust LSP with additional features
  "https://github.com/saecki/crates.nvim", -- Rust crates management
  "https://github.com/stevearc/conform.nvim", -- better formatting

  --
  -- TREESITTER
  --
  "https://github.com/nvim-treesitter/nvim-treesitter", -- syntax highlighter
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
    name = "catppuccin",
  },
  "https://github.com/nvim-lualine/lualine.nvim", -- nice looking status line at the bottom
  "https://github.com/nvim-tree/nvim-web-devicons", -- dependency of lualine
  "https://github.com/mrjones2014/smart-splits.nvim", -- integrate with wezterm splits

  --
  -- AI
  --
  "https://github.com/zbirenbaum/copilot.lua", -- suggestions
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
local conform = require("conform")

local function map(mode, key, action, opts)
  local options = {}
  if type(opts) == "string" then
    options.desc = opts
  elseif type(opts) == "table" then
    options = opts
  end
  vim.keymap.set(mode, key, action, options)
end

--
-- CORE
--
map("n", "U", "<C-r>", "Redo")

map("x", "p", [["_dP]], "Paste without yanking")
map({ "n", "v" }, "<leader>d", [["_d]], "Delete without yanking")

map({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard")
map("n", "<leader>Y", [["+Y]], "Yank line to system clipboard")
map({ "n", "x" }, "<leader>p", [["+p]], "Paste from system clipboard")
map({ "n", "x" }, "<leader>P", [["+P]], "Paste before from system clipboard")

-- Colemak fix for jumplist
map("n", "<C-i>", "<C-o>", "Jump back (Colemak)")
map("n", "<C-o>", "<C-i>", "Jump forward (Colemak)")

--
-- ITEM PICKER
--

-- Global
map("n", "<leader>fR", picker.resume, "Resume")
map("n", "<leader><space>", picker.grep, "Grep")
map("n", "<leader>ff", picker.files, "Find Files")
map("n", "<leader>fb", picker.buffers, "Buffers")
--vim.keymap.set("n", "<leader>fr", picker.recent, { desc = "Recent" })
map("n", "<leader>fe", picker.explorer, "File Explorer")
-- vim.keymap.set("n", "<leader>fg", picker.git_files, { desc = "Find Git Files" })
map("n", "<leader>fh", picker.help, "Help Pages")
map("n", "<leader>fk", picker.keymaps, "Keymaps")
map("n", "<leader>fs", picker.lsp_workspace_symbols, "LSP Workspace Symbols")
map({ "n", "x" }, "<leader>*", picker.grep_word, "Visual selection or word")

-- in buffer
map("n", "<leader>/", picker.lines, "Buffer Lines")
-- vim.keymap.set("n", "<leader>sB", picker.grep_buffers, { desc = "Grep Open Buffers" })

-- LSP
map("n", "gs", picker.lsp_symbols, "Goto Symbol")
map("n", "gd", picker.lsp_definitions, "Goto Definition")
map("n", "gD", picker.lsp_declarations, "Goto Declaration")
map("n", "gr", picker.lsp_references, { nowait = true, desc = "References" })
map("n", "gI", picker.lsp_implementations, "Goto Implementation")
map("n", "gy", picker.lsp_type_definitions, "Goto T[y]pe Definition")

--
-- CODE EDITING
--
map("n", "cK", vim.lsp.buf.signature_help, "Signature Help")
map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
map("n", "<leader>cf", conform.format, "Format buffer")
map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
map("n", "<leader>cA", function() -- run code actions only on the source (e.g. fix imports)
  vim.lsp.buf.code_action({
    context = { only = { "source" } },
  })
end, "Code Actions")

--
-- JUMPING
--
map({ "n", "x", "o" }, "s", flash.jump, "Flash")
map({ "n", "x", "o" }, "S", flash.treesitter, "Flash Treesitter")
map("o", "r", flash.remote, "Remote Flash")
map({ "o", "x" }, "R", flash.treesitter_search, "Treesitter Search")

--
-- WINDOW MANAGEMENT
--
map("n", "<leader><tab>", ":e #<CR>", "Toggle Buffer")
-- CTRL+W S/V to create splits
map("n", "<C-h>", splits.move_cursor_left, "Go to Left Window")
map("n", "<C-j>", splits.move_cursor_down, "Go to Bottom Window")
map("n", "<C-k>", splits.move_cursor_up, "Go to Top Window")
map("n", "<C-l>", splits.move_cursor_right, "Go to Right Window")
map("n", "<A-h>", splits.resize_left, "Shrink Window Horizontally")
map("n", "<A-j>", splits.resize_down, "Shrink Window Vertically")
map("n", "<A-k>", splits.resize_up, "Grow Window Vertically")
map("n", "<A-l>", splits.resize_right, "Grow Window Horizontally")
--vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

--
-- AI
--
map({ "n", "v" }, "<leader>aa", chat.toggle, "Toggle (CopilotChat)")
map({ "n", "v" }, "<leader>ap", chat.select_prompt, "Prompt Actions (CopilotChat)")
map({ "n", "v" }, "<leader>ax", chat.reset, "Clear (CopilotChat)")

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

    map({ "n", "x" }, "J", rlsp("joinLines"), "Join lines")
    map("n", "K", rlsp("hover actions"), "Hover actions")
    -- not working map("v", "K", rlsp("hover range"), "Hover actions")
    map("n", "<leader>ca", rlsp("codeAction"), "Code actions")
    -- TODO not existing, but optimize import would be nice
    -- map("n", "<leader>cA", rlsp("codeAction source"), "Rust: Source actions")

    map("n", "gu", rlsp("parentModule"), "Parent module (Go Up)")

    map("n", "<leader>cd", rlsp("renderDiagnostic"), "Render Diagnostic")
    map("n", "<leader>ce", rlsp("explainError"), "Explain Error")
    map("n", "<leader>cm", rlsp("expandMacro"), "Expand Macro")

    -- map("n", "<leader>rr",   rlsp("runnables"),             "Rust: Runnables")
    -- map("n", "<leader>rt",   rlsp("testables"),             "Rust: Testables")
  end,
})

require("which-key").setup({
  preset = "helix",
  show_help = false,
})

require("snacks").setup({
  picker = {}, -- enable picker
  explorer = {}, -- enable explorer
})

require("mini.ai").setup()
-- require("rainbow-delimiters.setup").setup()

require("smart-splits").setup({})

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

--
-- LSP
--
-- LSP is the “language server” — it understands code semantics and helps with editing and refactoring.
-- no Mason, install LSPs manually with homebrew
-- debug with :LspInfo
vim.lsp.enable({ "lua_ls" })

vim.diagnostic.config({
  -- diagnostic on extra lines, disabled for now as lines are jumping around
  virtual_text = false,
  -- only on current line
  virtual_lines = {
    current_line = true,
  },
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- enable built-in completion if LSP supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/completion") then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Configure Formatters
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

--
-- TREESITTER
--
-- Treesitter is the “syntax tree parser” — it understands code structure and helps with navigation, highlighting, and text manipulation.
-- syntax highlighting. Update with :TSUpdate and install new with :TSInstall or add to list
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "vimdoc",
    "vim",
    "bash",
    "fish",
    "rust",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false, -- for Catpucchin
  },
  indent = { enable = true },
})

--
-- STYLE
--
require("lualine").setup()
vim.cmd.colorscheme("catppuccin-mocha")

--
-- AI
--
require("copilot").setup({
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
  },
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
