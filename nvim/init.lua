-- Interesting examples:
--   https://github.com/m:qqqplusp/nvim-0.12-vim-pack-intro
--   https://gpanders.com/blog/whats-new-in-neovim-0-11/#lspa
--   https://github.com/SylvanFranklin/.config/blob/main/nvim/init.lua

vim.pack.add({
  --
  -- CORE
  --
  "https://github.com/folke/which-key.nvim", -- keybinding help
  "https://github.com/folke/snacks.nvim", -- item picker popup
  "https://github.com/dfrommi/snacks-call-hierarchy.nvim", -- my extension for call hierarchy on top of snacks
  "https://github.com/echasnovski/mini.files", -- file explorer
  "https://github.com/folke/flash.nvim", -- jump around
  "https://github.com/echasnovski/mini.ai", -- text objects and surrounding text manipulation
  "https://github.com/echasnovski/mini.surround", -- text objects and surrounding text manipulation
  -- "https://github.com/HiPhish/rainbow-delimiters.nvim", -- rainbow brackets
  "https://github.com/j-hui/fidget.nvim", -- LSP status info

  --
  -- LSP
  --
  "https://github.com/neovim/nvim-lspconfig", -- configures LSP servers
  "https://github.com/mason-org/mason.nvim", -- manage LSP servers, formatters, linters
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- automatically install tools, instead of manually via :MasonInstall
  "https://github.com/stevearc/conform.nvim", -- better formatting
  "https://github.com/mfussenegger/nvim-jdtls", -- Java LSP with extended code actions
  "https://github.com/NickJAllen/java-helpers.nvim", -- Java file creation and stack traces
  "https://github.com/mrcjkb/rustaceanvim", -- Rust LSP with additional features
  "https://github.com/saecki/crates.nvim", -- Rust crates management

  --
  -- DEBUGGING
  --
  "https://github.com/mfussenegger/nvim-dap", -- Debug Adapter Protocol client
  "https://github.com/rcarriga/nvim-dap-ui", -- debugging UI panels

  --
  -- TESTING
  --
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/rcasia/neotest-java", -- Java neotest adapter

  --
  -- TREESITTER
  --
  -- syntax highlighter
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },

  --
  -- AI
  --
  "https://github.com/coder/claudecode.nvim", -- Claude Code IDE integration

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
  -- DEPENDENCIES
  --
  "https://github.com/nvim-lua/plenary.nvim", -- dependency of many plugins
  "https://github.com/nvim-tree/nvim-web-devicons", -- dependency of lualine
  "https://github.com/nvim-neotest/nvim-nio", -- dependency of neotest
})

require("my.options")
require("my.core")

require("my.completion")

require("my.lang.lua")
require("my.lang.rust")
require("my.lang.markdown")
require("my.lang.java")

require("my.dap")
require("my.claude")

-- has to be after lang because other modules add config to it
require("my.code").setup()

-- very last to make sure everything is loaded and available
require("my.keymap").setup()
