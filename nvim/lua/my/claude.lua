-- Setup claudecode.nvim with the WezTerm provider
require("claudecode").setup({
  terminal = {
    provider = require("adapter.claude.wezterm"),
    split_side = "right",
    split_width_percentage = 0.30,
  },
  git_repo_cwd = true,
})
