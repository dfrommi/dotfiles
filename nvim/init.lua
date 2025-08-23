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
  "https://github.com/echasnovski/mini.files", -- file explorer
  "https://github.com/folke/flash.nvim", -- jump around
  "https://github.com/echasnovski/mini.ai", -- text objects and surrounding text manipulation
  "https://github.com/echasnovski/mini.surround", -- text objects and surrounding text manipulation
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
  "https://github.com/supermaven-inc/supermaven-nvim",
  "https://github.com/NickvanDyke/opencode.nvim", -- extract prompt for coding agents

  --
  -- DEPENDENCIES
  --
  "https://github.com/nvim-lua/plenary.nvim", -- common dependency (e.g. CopilotChat)
  "https://github.com/nvim-tree/nvim-web-devicons", -- dependency of lualine
})

require("my.options")
require("my.core")

require("my.completion")
require("my.assistant")

require("my.lang.lua")
require("my.lang.rust")
require("my.lang.markdown")

-- has to be after lang because other modules add config to it
require("my.code").setup()

-- very last to make sure everything is loaded and available
require("my.keymap")
