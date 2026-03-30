vim.lsp.config("copilot", {
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
  },
})

require("my.code").lsp("copilot")
require("my.code").mason("copilot-language-server")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    if not client then
      return
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
    end
  end,
})

local M = {}

function M.next()
  vim.lsp.inline_completion.select({})
end

function M.accept()
  vim.lsp.inline_completion.get()
end

return M
