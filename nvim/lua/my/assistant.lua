local keymap = require("my.keymap")

require("sidekick").setup({
  -- NES enabled with defaults; Tab is NOT bound here — use <leader>aj instead
  cli = {
    win = {
      layout = "right",
    },
  },
})

keymap.sidekick_bindings()
