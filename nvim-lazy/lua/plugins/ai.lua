local M = {
  -- {
  --   "saghen/blink.cmp",
  --
  --   opts = {
  --     keymap = {
  --       ["<S-Tab>"] = {
  --         LazyVim.cmp.map({ "snippet_backward", "ai_accept_word" }),
  --         "fallback",
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = {
  --     suggestion = {
  --       auto_trigger = false,
  --     },
  --   },
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,

    opts = function()
      require("supermaven-nvim.completion_preview").suggestion_group = "SupermavenSuggestion"

      -- Would be nice to just extend and reuse lazyvim config, but don't see how atm

      local ai_accept = function(partial)
        return function()
          local suggestion = require("supermaven-nvim.completion_preview")
          if suggestion.has_suggestion() then
            LazyVim.create_undo()
            vim.schedule(function()
              suggestion.on_accept_suggestion(partial)
            end)
            return true
          end
        end
      end

      LazyVim.cmp.actions.ai_accept = ai_accept(false)
      LazyVim.cmp.actions.ai_accept_word = ai_accept(true)
    end,
  },

  {
    "yetone/avante.nvim",
    enabled = false,

    event = "VeryLazy",
    --lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "openai",
      auto_suggestions_provider = "openai",
      behaviour = {
        auto_suggestions = false,
      },
      hints = { enabled = true },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "robitx/gp.nvim",
    enabled = false,

    keys = {
      { "<leader>af", "<cmd>GpChatFinder<cr>", desc = "AI chat finder" },

      { "<leader>aa", "<cmd>GpChatToggle popup<cr>", desc = "AI popup toggle" },
      { "<leader>aA", "<cmd>GpChatNew popup<cr>", desc = "AI popup new" },
      { "<leader>av", "<cmd>GpChatToggle vsplit<cr>", desc = "AI vsplit toggle" },
      { "<leader>aV", "<cmd>GpChatNew vsplit<cr>", desc = "AI vsplit new" },
      { "<leader>ar", "<cmd>GpRewrite<cr>", desc = "AI rewrite" },
      { "<leader>aP", "<cmd>GpPrepend<cr>", desc = "AI prepend" },
      { "<leader>ap", "<cmd>GpAppend<cr>", desc = "AI append" },
      { "<leader>ai", "<cmd>GpImplement<cr>", desc = "AI implement" },

      { "<leader>aa", mode = "v", ":<C-u>'<,'>GpChatToggle popup<cr>", desc = "AI popup toggle" },
      { "<leader>aA", mode = "v", ":<C-u>'<,'>GpChatNew popup<cr>", desc = "AI popup new" },
      { "<leader>av", mode = "v", ":<C-u>'<,'>GpChatToggle vsplit<cr>", desc = "AI vsplit toggle" },
      { "<leader>aV", mode = "v", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "AI vsplit new" },
      { "<leader>ar", mode = "v", ":<C-u>'<,'>GpRewrite<cr>", desc = "AI rewrite" },
      { "<leader>aP", mode = "v", ":<C-u>'<,'>GpPrepend<cr>", desc = "AI prepend" },
      { "<leader>ap", mode = "v", ":<C-u>'<,'>GpAppend<cr>", desc = "AI append" },
      { "<leader>ai", mode = "v", ":<C-u>'<,'>GpImplement<cr>", desc = "AI implement" },
    },

    opts = {
      default_command_agent = "ChatGPT4o",
      default_chat_agent = "CodeGPT4o",
    },
  },
}

return M
