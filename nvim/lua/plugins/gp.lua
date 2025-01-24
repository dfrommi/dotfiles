local M = {
  "robitx/gp.nvim",

  keys = {
    { "<leader>af", "<cmd>GpChatFinder<cr>", desc = "AI chat finder" },

    { "<leader>aa", "<cmd>GpChatToggle popup<cr>", desc = "AI popup toggle" },
    { "<leader>aA", "<cmd>GpChatNew popup<cr>", desc = "AI popup new" },
    { "<leader>av", "<cmd>GpChatToggle vsplit<cr>", desc = "AI vsplit toggle" },
    { "<leader>aV", "<cmd>GpChatNew vsplit<cr>", desc = "AI vsplit new" },
    { "<leader>ar", "<cmd>GpRewrite<cr>", desc = "AI rewrite" },
    { "<leader>aP", "<cmd>GpPrepend<cr>", desc = "AI prepend" },
    { "<leader>ap", "<cmd>GpAppend<cr>", desc = "AI append" },
    { "<leader>ai", "<cmd>GpImplement<cr>", desc = "AI implement" },

    { "<leader>aa", mode = "v", ":<C-u>'<,'>GpChatToggle popup<cr>", desc = "AI popup toggle" },
    { "<leader>aA", mode = "v", ":<C-u>'<,'>GpChatNew popup<cr>", desc = "AI popup new" },
    { "<leader>av", mode = "v", ":<C-u>'<,'>GpChatToggle vsplit<cr>", desc = "AI vsplit toggle" },
    { "<leader>aV", mode = "v", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "AI vsplit new" },
    { "<leader>ar", mode = "v", ":<C-u>'<,'>GpRewrite<cr>", desc = "AI rewrite" },
    { "<leader>aP", mode = "v", ":<C-u>'<,'>GpPrepend<cr>", desc = "AI prepend" },
    { "<leader>ap", mode = "v", ":<C-u>'<,'>GpAppend<cr>", desc = "AI append" },
    { "<leader>ai", mode = "v", ":<C-u>'<,'>GpImplement<cr>", desc = "AI implement" },
  },

  opts = {
    default_command_agent = "ChatGPT4o",
    default_chat_agent = "CodeGPT4o",
  },
}

return M
