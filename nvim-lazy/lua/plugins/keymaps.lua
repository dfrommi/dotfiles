local Util = require("lazyvim.util")

local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>ft",
      function()
        require("neo-tree.command").execute({
          source = "filesystem",
          action = "focus",
          reveal = true,
          dir = Util.root(),
        })
      end,
      desc = "Explorer NeoTree (root dir)",
    },
    {
      "<leader>fT",
      function()
        require("neo-tree.command").execute({
          source = "filesystem",
          action = "focus",
          reveal = true,
          dir = vim.loop.cwd(),
        })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
  },
  -- opts = {
  --   window = {
  --     mappings = {
  --       -- same as activation. From, buffer, focus with one <C-n>, close with 2 times <C-n>
  --       ["<C-n>"] = "close_window",
  --     },
  --   },
  -- },
}

local telescope = {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>/", Util.telescope("live_grep"), desc = "Grep" },
    -- { "<leader>*", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word under cursor" },
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "[F]ind [B]uffer" },
    { "<leader>ff", Util.telescope("files"), desc = "[F]ind [F]iles" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "[F]ind [D]iagnostics (file)" },
    { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "[F]ind [D]iagnostics (workspace)" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "[F]ind [Help]" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "[F]ind [K]eymaps" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "[F]ind [M]ark" },
  },
}

local flash = {
  "folke/flash.nvim",
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Jump [S]earch", },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Jump [S]earch to Keyword", },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Select Search", },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Select Search to Keyword", },
  },
}

local conform = {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" } })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
}

return {
  neotree,
  telescope,
  flash,
  conform,
}
