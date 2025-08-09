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

  -- auto-closing brackets
  "echasnovski/mini.pairs",
}

for _, k in ipairs(disabled) do
  --print(k.." - _ disabled")
  table.insert(M, { k, enabled = false })
end

return M
