local M = {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        --provider = "openai",
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            name = "Ollama",
            api_key = "USER", -- mandatory for the plugin
            -- model = "deepseek-coder:6.7b",
            model = "deepseek-coder",
            end_point = "http://localhost:11434/v1/chat/completions",
            stream = false,
          },
        },
      })
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-cmp",
    opts = function(_, opts)
      -- if you wish to use autocomplete
      table.insert(opts.sources, 1, {
        name = "minuet",
        group_index = 1,
        priority = 100,
      })

      opts.performance = {
        -- It is recommended to increase the timeout duration due to
        -- the typically slower response speed of LLMs compared to
        -- other completion sources. This is not needed when you only
        -- need manual completion.
        fetching_timeout = 5000,
      }

      opts.mapping = vim.tbl_deep_extend("force", opts.mapping or {}, {
        -- if you wish to use manual complete
        ["<A-y>"] = require("minuet").make_cmp_map(),
        -- You don't need to worry about <CR> delay because lazyvim handles this situation for you.
        ["<CR>"] = nil,
      })
    end,
  },
}

return {}
