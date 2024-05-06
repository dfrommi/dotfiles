local M = {}

-- start filename with _ to process this file first

--
-- DISABLE PLUGINS
--

local disabled = {
  -- trying to work without 'tab' line
  "akinsho/bufferline.nvim",

  -- not working with sessions yet
  "echasnovski/mini.bufremove",
  "folke/persistence.nvim",

  -- flash is most likely what I will use instead
  "echasnovski/mini.surround",

  -- Multi-file search-panel
  "nvim-pack/nvim-spectre",

  -- no dashboard needed
  "nvimdev/dashboard-nvim",

  -- auto-closing bracketr
  "echasnovski/mini.pairs",

  -- experimental UI stuff
  -- "stevearc/dressing.nvim",
  -- "folke/noice.nvim",
  "rcarriga/nvim-notify",
}

for _, k in ipairs(disabled) do
  --print(k.." - _ disabled")
  table.insert(M, { k, enabled = false })
end

--
-- REMOVE ALL PREDEFINED KEY BINDINGS
--
-- TODO LSP

-- Official interface not yet available: require('lazy').plugins()
local plugins = require("lazy.core.config").spec.fragments
--print(vim.inspect(plugins))

for _, plugin in pairs(plugins) do
  local alreadyProcessed = vim.tbl_contains(
    vim.tbl_map(function(v)
      return v[1]
    end, M),
    plugin[1]
  )
  local optional = plugin.optional == true or (type(plugin.optional) == "function" and plugin.optional())

  if not optional and not alreadyProcessed then
    local enabled = not (plugin.enabled == false or (type(plugin.enabled) == "function" and not plugin.enabled()))
    if enabled and plugin.keys ~= nil and not vim.tbl_contains(disabled, plugin[1]) then
      -- print(plugin[1].." - keys removed")
      table.insert(M, {
        plugin[1],
        keys = function()
          return {}
        end,
      })
    end
  end
end

return M
