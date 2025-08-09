return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>se",
        function()
          require("telescope.builtin").diagnostics({
            bufnr = 0,
            severity = vim.diagnostic.severity.ERROR,
          })
        end,
        desc = "Document Errors",
      },
      {
        "<leader>sE",
        function()
          require("telescope.builtin").diagnostics({
            severity = vim.diagnostic.severity.ERROR,
          })
        end,
        desc = "Workspace Errors",
      },
    },
  },
}
