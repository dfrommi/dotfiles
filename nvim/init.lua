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
  "https://github.com/mason-org/mason.nvim", -- manage LSP servers, formatters, linters
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- automatically install tools, instead of manually via :MasonInstall
  "https://github.com/mrcjkb/rustaceanvim", -- Rust LSP with additional features
  "https://github.com/saecki/crates.nvim", -- Rust crates management
  "https://github.com/stevearc/conform.nvim", -- better formatting

  --
  -- TREESITTER
  --
  "https://github.com/nvim-treesitter/nvim-treesitter", -- syntax highlighter
  "https://github.com/nvim-treesitter/nvim-treesitter-context", -- show surrounding context on top of editor

  --
  -- TOOLS
  --
  "https://github.com/lewis6991/gitsigns.nvim", -- show git changes in the gutter
  "https://github.com/MeanderingProgrammer/render-markdown.nvim", -- render markdown

  --
  -- UI
  --
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
  },
  "https://github.com/nvim-lualine/lualine.nvim", -- nice looking status line at the bottom
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
  "https://github.com/nvim-tree/nvim-web-devicons", -- dependency of lualine
})

local picker = require("snacks").picker
local flash = require("flash")
local chat = require("CopilotChat")
local splits = require("smart-splits")
local conform = require("conform")

local function keymap(mode, key, action, opts)
  local options = type(opts) == "string" and { desc = opts } or opts
  vim.keymap.set(mode, key, action, options)
end

--
-- CORE
--
keymap("n", "U", "<C-r>", "Redo [<C-r>]")
keymap("x", "J", ":m '>+1<CR>gv=gv", "Move selection down")
keymap("x", "K", ":m '<-2<CR>gv=gv", "Move selection up")

keymap("x", "p", [["_dP]], "Paste without yanking")
keymap({ "n", "v" }, "<leader>d", [["_d]], "Delete without yanking")

keymap({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard")
keymap("n", "<leader>Y", [["+Y]], "Yank line to system clipboard")
keymap({ "n", "x" }, "<leader>p", [["+p]], "Paste from system clipboard")
keymap({ "n", "x" }, "<leader>P", [["+P]], "Paste before from system clipboard")

--
-- ITEM PICKER
--

-- Global
keymap("n", "<leader>fR", picker.resume, "Resume")
keymap("n", "<leader><space>", picker.grep, "Grep") -- TODO maybe not the best mapping, should be most used one
keymap("n", "<leader>ff", picker.files, "Find Files")
keymap("n", "<leader>fb", picker.buffers, "Buffers")
--vim.keymap.set("n", "<leader>fr", picker.recent, { desc = "Recent" })
keymap("n", "<leader>fe", picker.explorer, "File Explorer")
-- vim.keymap.set("n", "<leader>fg", picker.git_files, { desc = "Find Git Files" })
keymap("n", "<leader>fh", picker.help, "Help Pages")
keymap("n", "<leader>fk", picker.keymaps, "Keymaps")
keymap("n", "<leader>fs", picker.lsp_workspace_symbols, "LSP Workspace Symbols [gO]")
keymap({ "n", "x" }, "<leader>*", picker.grep_word, "Visual selection or word")

-- in buffer
keymap("n", "<leader>/", picker.lines, "Buffer Lines")
-- vim.keymap.set("n", "<leader>sB", picker.grep_buffers, { desc = "Grep Open Buffers" })

-- LSP
-- TODO incoming/outgoing calls. Not yet in SnAcks.picker
-- TODO evaluate using locatonList directly
keymap("n", "gs", picker.lsp_symbols, "Goto Symbol")
keymap("n", "gd", picker.lsp_definitions, "Goto Definition")
keymap("n", "gD", picker.lsp_declarations, "Goto Declaration")
keymap("n", "gr", picker.lsp_references, { nowait = true, desc = "References [grr]" })
keymap("n", "gI", picker.lsp_implementations, "Goto Implementation [gri]")
keymap("n", "gy", picker.lsp_type_definitions, "Goto T[y]pe Definition [grt]")

--
-- CODE EDITING
--
keymap("n", "<leader>cK", vim.lsp.buf.signature_help, "Signature Help")
keymap("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help [CTRL-S]")
keymap("n", "<leader>cf", conform.format, "Format buffer")
keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions [gra]")
keymap("n", "<leader>cA", function() -- run code actions only on the source (e.g. fix imports)
  vim.lsp.buf.code_action({
    context = { only = { "source" } },
  })
end, "Code Actions")
keymap("n", "<leader>cr", vim.lsp.buf.rename, "Rename [grn]")
keymap("n", "<leader>cR", Snacks.rename.rename_file, "Rename File")

--
-- JUMPING
--

-- Colemak fix for jumplist
-- e and i can be used for up/down jumping
keymap("n", "<C-h>", "<C-o>", "Jump back (Colemak) [<C-o>]")
keymap("n", "<C-l>", "<C-i>", "Jump forward (Colemak) [<C-i>]")

keymap({ "n", "x", "o" }, "s", flash.jump, "Flash")
keymap({ "n", "x", "o" }, "S", flash.treesitter, "Flash Treesitter")
keymap("o", "r", flash.remote, "Remote Flash")
keymap({ "o", "x" }, "R", flash.treesitter_search, "Treesitter Search")

--
-- WINDOW MANAGEMENT
--
keymap("n", "<leader>bb", "<C-^>", "Toggle Buffer [<C-^>]")
-- CTRL+W S/V to create splits
keymap("n", "<C-n>", splits.move_cursor_left, "Go to Left Window [<C-w>h]")
keymap("n", "<C-e>", splits.move_cursor_down, "Go to Bottom Window [<C-w>j]")
keymap("n", "<C-i>", splits.move_cursor_up, "Go to Top Window [<C-w>k]")
keymap("n", "<C-o>", splits.move_cursor_right, "Go to Right Window [<C-w>l]")
-- keymap("n", "<A-n>", splits.resize_left, "Shrink Window Horizontally [<C-w><]")
-- keymap("n", "<A-e>", splits.resize_down, "Shrink Window Vertically [<C-w>-]")
-- keymap("n", "<A-i>", splits.resize_up, "Grow Window Vertically [<C-w>+]")
-- keymap("n", "<A-o>", splits.resize_right, "Grow Window Horizontally [<C-w>>]")
--vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

--
-- AI
--
keymap({ "n", "v" }, "<leader>aa", chat.toggle, "Toggle Chat")
keymap({ "n", "v" }, "<leader>ax", chat.reset, "Clear")
keymap("x", "<leader>ap", function()
  chat.quick_prompt()
end, "Quick Prompt")
keymap({ "n", "v" }, "<leader>aP", chat.select_prompt, "Prompt Actions")

local copilot_cmp_keymap = {
  accept = "<tab>",
  accept_word = "<S-tab>",
  accept_line = "<M-tab>",
  next = "<M-j>",
  prev = "<M-k>",
  -- dismiss = "<M-h>",
}

local function git_signs_bindings(map, gs)
  -- map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  -- map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
  map("n", "<leader>gd", gs.preview_hunk_inline, "Diff Hunk Inline")
  -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

local function rust_bindings(map, rlsp)
  --TODO move up and down bindings
  map("n", "J", rlsp("joinLines"), "Join lines")
  map("n", "K", rlsp("hover actions"), "Hover actions")

  map("x", "J", rlsp("moveItem up"), "Move selection down")
  map("x", "K", rlsp("moveItem down"), "Move selection up")

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
end

local tools_config = {
  treesitter = {
    "vimdoc",
    "vim",
    "bash",
    "fish",
    "json",
    "yaml",
    "toml",
  },
  formatters_by_ft = {},
  mason = {},
  lsp_enabled = {},
}

--
-- LUA
--
table.insert(tools_config.treesitter, "lua")
table.insert(tools_config.lsp_enabled, "lua_ls")
tools_config.formatters_by_ft["lua"] = { "stylua" }
vim.list_extend(tools_config.mason, {
  "lua-language-server", -- Lua LSP
  "stylua", -- Lua formatter
})

--
-- RUST
--
-- using global LSP instead of mason
-- no setup needed for rustaceanvim, it will automatically install the LSP
table.insert(tools_config.treesitter, "rust")

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

    rust_bindings(map, rlsp)
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

--
-- MARKDOWN
--
vim.list_extend(tools_config.treesitter, {
  "markdown",
  "markdown_inline",
  "html", -- for inline HTML in Markdown
})
tools_config.formatters_by_ft["markdown"] = { "markdownlint-cli2", "markdown-toc" }

table.insert(tools_config.lsp_enabled, "marksman")
tools_config.mason = vim.list_extend(tools_config.mason, {
  "marksman", -- Markdown LSP
  "markdownlint-cli2", -- Markdown linter
  "markdown-toc", -- Markdown table of contents generator
})

require("render-markdown").setup({
  filetypes = { "markdown", "copilot-chat" },
  completions = { lsp = { enabled = true } },
})

--
-- SYNTAX HIGHLIGHTING
--
-- Treesitter is the “syntax tree parser” — it understands code structure and helps with navigation, highlighting, and text manipulation.
-- syntax highlighting. Update with :TSUpdate and install new with :TSInstall or add to list
require("nvim-treesitter.configs").setup({
  ensure_installed = tools_config.treesitter,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false, -- for Catpucchin
  },
  indent = { enable = true },
})

--
-- LSP
--
-- LSP is the “language server” — it understands code semantics and helps with editing and refactoring.
-- no Mason, install LSPs manually with homebrew
-- debug with :LspInfo
vim.lsp.enable(tools_config.lsp_enabled)

vim.diagnostic.config({
  virtual_text = true,
  --   -- diagnostic on extra lines
  --   -- virtual_lines = {
  --   --   current_line = true,
  --   -- },
  --   signs = {
  --     active = true,
  --     text = {
  --       [vim.diagnostic.severity.ERROR] = "",
  --       [vim.diagnostic.severity.WARN] = "",
  --       [vim.diagnostic.severity.HINT] = "",
  --       [vim.diagnostic.severity.INFO] = "",
  --     },
  --   },
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
  formatters_by_ft = tools_config.formatters_by_ft,
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

--
-- CORE PLUGINS
--
require("lualine").setup()
vim.cmd.colorscheme("catppuccin-mocha")

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

require("gitsigns").setup({
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end

    git_signs_bindings(map, gs)
  end,
})

require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = tools_config.mason,
})

--
-- AI
--
require("copilot").setup({
  panel = {
    enabled = false,
  },
  suggestion = {
    auto_trigger = true,
    keymap = copilot_cmp_keymap,
  },
})

require("CopilotChat").setup({
  -- For render-markdown.nvim - see https://github.com/CopilotC-Nvim/CopilotChat.nvim/wiki/Examples-and-Tips#markdown-rendering
  highlight_headers = false,
  separator = "---",
  error_header = "> [!ERROR] Error",
})

-- clean up CopilotChat buffer
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

chat.quick_prompt = function(prompt)
  if not prompt or prompt == "" then
    prompt = vim.fn.input("# ")
  end

  if prompt ~= "" then
    chat.reset() -- clear previous chat
    chat.ask(prompt, {
      window = {
        layout = "float",
        relative = "cursor",
        width = 0.5,
        height = 0.4,
        row = 1,
      },
    })
  end
end
