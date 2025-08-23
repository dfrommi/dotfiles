local M = {}

local tools_config = {
  treesitter = {
    "vimdoc",
    "vim",
    "bash",
    "fish",
    "json",
    "yaml",
    "toml",
  },
  formatters_by_ft = {},
  mason = {},
  lsp_enabled = {},
}

vim.diagnostic.config({
  virtual_text = true,
  --   -- diagnostic on extra lines
  --   -- virtual_lines = {
  --   --   current_line = true,
  --   -- },
  --   signs = {
  --     active = true,
  --     text = {
  --       [vim.diagnostic.severity.ERROR] = "",
  --       [vim.diagnostic.severity.WARN] = "",
  --       [vim.diagnostic.severity.HINT] = "",
  --       [vim.diagnostic.severity.INFO] = "",
  --     },
  --   },
})

vim.api.nvim_create_user_command("WorkspaceErrors", function()
  local diags = vim.diagnostic.get(nil, {
    severity = { min = vim.diagnostic.severity.ERROR },
  })
  local items = vim.diagnostic.toqflist(diags)
  vim.fn.setqflist(items, "r")
  vim.cmd.copen()
end, { desc = "Show ERROR diagnostics for workspace" })

function M.lsp(name)
  if not vim.tbl_contains(tools_config.lsp_enabled, name) then
    table.insert(tools_config.lsp_enabled, name)
  end
end

function M.mason(name)
  if not vim.tbl_contains(tools_config.mason, name) then
    table.insert(tools_config.mason, name)
  end
end

function M.treesitter(name)
  if not vim.tbl_contains(tools_config.treesitter, name) then
    table.insert(tools_config.treesitter, name)
  end
end

function M.conform(ft, formatter)
  if not tools_config.formatters_by_ft[ft] then
    tools_config.formatters_by_ft[ft] = {}
  end
  if not vim.tbl_contains(tools_config.formatters_by_ft[ft], formatter) then
    table.insert(tools_config.formatters_by_ft[ft], formatter)
  end
end

function M.setup()
  --
  -- SYNTAX HIGHLIGHTING
  --
  -- Treesitter is the “syntax tree parser” — it understands code structure and helps with navigation, highlighting, and text manipulation.
  -- syntax highlighting. Update with :TSUpdate and install new with :TSInstall or add to list
  require("nvim-treesitter.configs").setup({
    ensure_installed = tools_config.treesitter,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false, -- for Catpucchin
    },
    indent = { enable = true },
  })

  --
  -- LSP
  --
  -- LSP is the “language server” — it understands code semantics and helps with editing and refactoring.
  -- no Mason, install LSPs manually with homebrew
  -- debug with :LspInfo
  vim.lsp.enable(tools_config.lsp_enabled)

  -- Configure Formatters
  require("conform").setup({
    formatters_by_ft = tools_config.formatters_by_ft,
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  })

  -- Install defendencies with Mason
  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = tools_config.mason,
  })
end

--
-- highlight symbol under cursor
--
-- time to wait before triggering the CursorHold event
vim.opt.updatetime = 500

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

return M
