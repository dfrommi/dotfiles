vim.lsp.config("copilot", {
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
  },
})

require("my.code").lsp("copilot")
require("my.code").mason("copilot-language-server")
