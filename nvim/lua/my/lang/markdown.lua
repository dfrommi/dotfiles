local code = require("my.code")

code.treesitter("markdown")
code.treesitter("markdown_inline")
code.treesitter("html") -- for inline HTML in Markdown
code.conform("markdown", "markdownlint-cli2")
code.conform("markdown", "markdown-toc")

code.lsp("marksman")
code.mason("marksman") -- Markdown LSP
code.mason("markdownlint-cli2") -- Markdown linter
code.mason("markdown-toc") -- Markdown table of contents generator

require("render-markdown").setup({
  filetypes = { "markdown", "copilot-chat" },
  completions = { lsp = { enabled = true } },
})
