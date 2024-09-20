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

  -- auto-closing brackets
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

return M
