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
  mason = {
    "tree-sitter-cli",
  },
  lsp_enabled = {},
  test_adapters = {},
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

function M.lsp(name, opts)
  opts = opts or {}
  tools_config.lsp_enabled[name] = {
    config = opts.config,
    on_attach = opts.on_attach,
  }
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

function M.test_adapter(name)
  if not vim.tbl_contains(tools_config.test_adapters, name) then
    table.insert(tools_config.test_adapters, name)
  end
end

function M.setup()
  --
  -- SYNTAX HIGHLIGHTING
  --
  -- Treesitter is the “syntax tree parser” — it understands code structure and helps with navigation, highlighting, and text manipulation.
  -- syntax highlighting. Update with :TSUpdate and install new with :TSInstall or add to list
  require("nvim-treesitter").install(tools_config.treesitter)

  -- Treesitter only provides parsers, Neovim has to make use of it.
  -- Pattern limits the autocmd to filetypes with installed parsers only.
  vim.api.nvim_create_autocmd("FileType", {
    pattern = require("nvim-treesitter").get_installed(),
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })

  --
  -- LSP
  --
  -- LSP is the “language server” — it understands code semantics and helps with editing and refactoring.
  -- no Mason, install LSPs manually with homebrew
  -- debug with :LspInfo
  for name, entry in pairs(tools_config.lsp_enabled) do
    if entry.config then
      vim.lsp.config(name, entry.config)
    end
    vim.lsp.enable(name)
  end

  -- Single LspAttach: global behavior + per-LSP dispatch
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end

      -- Global: document highlighting
      if client:supports_method("textDocument/documentHighlight") then
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

      -- Per-LSP on_attach dispatch
      local entry = tools_config.lsp_enabled[client.name]
      if entry and entry.on_attach then
        entry.on_attach(client, ev.buf)
      end
    end,
  })

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

  -- Neotest
  require("neotest").setup({
    adapters = tools_config.test_adapters,
  })
end

--
-- highlight symbol under cursor
--
-- time to wait before triggering the CursorHold event
vim.opt.updatetime = 500

return M
