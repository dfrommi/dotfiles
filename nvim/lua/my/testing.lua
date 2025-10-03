local M = {}

function M.setup()
  local neotest = require("neotest")
  local rust = require("rustaceanvim.neotest")

  neotest.setup({
    adapters = { rust },
  })
end

return M
