require("my.completion.copilot_lsp")

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = {
      function(cmp)
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        if line:sub(1, col):match("^%s*$") then
          return
        end

        if cmp.is_menu_visible() then
          return cmp.select_and_accept()
        end

        return cmp.show()
      end,
      "snippet_forward",
      "fallback",
    },
    ["<Esc>"] = {
      function(cmp)
        if cmp.is_menu_visible() then
          return cmp.cancel()
        end
      end,
      "fallback",
    },
  },
  completion = {
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    ghost_text = {
      enabled = true,
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot" },
    providers = {
      copilot = {
        name = "Copilot",
        module = "blink-copilot",
        async = true,
      },
    },
  },
})
