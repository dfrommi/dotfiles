local M = {
  {
    "supermaven-inc/supermaven-nvim",
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
    "saghen/blink.cmp",

    opts = {
      keymap = {
        ["<S-Tab>"] = {
          LazyVim.cmp.map({ "snippet_backward", "ai_accept_word" }),
          "fallback",
        },
      },
    },
  },
}

return M
