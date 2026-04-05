local claude_native = true
local keymap = require("my.keymap")

require("sidekick").setup({
  cli = {
    mux = { enabled = true },
  },
})
require("sidekick.cli.session").register("wezterm", require("adapter.sidekick.wezterm"))
vim.schedule(function()
  require("sidekick.config").cli.mux.backend = "wezterm"
end)
keymap.sidekick_nes_bindings()

if claude_native then
  require("claudecode").setup({
    terminal = {
      provider = require("adapter.claude.wezterm"),
      split_side = "right",
    },
    window = {
      split_ratio = 0.5,
    },
  })
  keymap.claude_bindings()
else
  keymap.sidekick_cli_bindings()
end
