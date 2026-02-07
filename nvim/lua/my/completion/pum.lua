-- see https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc
--
vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
vim.opt.pumheight = 10 -- max lines in popup menu
vim.opt.pumborder = "rounded"

-- enable built-in completion if LSP supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    if not client then
      return
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, bufnr) then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}
      -- for i = 32, 126 do
      --   table.insert(chars, string.char(i))
      -- end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end,
})

local function feed(keys)
  -- mode n (noremap) skips custom mappings thus avoids endless recursion
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function pum_selected()
  local info = vim.fn.complete_info({ "selected" })
  return info and info.selected >= 0 or false
end

local M = {}

function M.is_visible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

function M.show()
  feed("<C-x><C-o>")
end

function M.dismiss()
  feed("<C-e>")
end

function M.accept()
  if pum_selected() then
    feed("<C-y>")
  else
    feed("<C-n><C-y>")
  end
end

function M.accept_if_selected()
  if pum_selected() then
    feed("<C-y>")
    return true
  end
end

function M.next()
  feed("<C-n>")
end

-- function M.prev()
--   feed "<C-p>"
-- end

return M
