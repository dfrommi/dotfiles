local keymap = require("my.keymap")

require("sidekick").setup({
  cli = {
    mux = { enabled = true },
  },
})

-- Register backend and override config after scheduled validation has run
require("sidekick.cli.session").register("wezterm", require("adapter.sidekick.wezterm"))
vim.schedule(function()
  require("sidekick.config").cli.mux.backend = "wezterm"
end)

keymap.sidekick_bindings()
