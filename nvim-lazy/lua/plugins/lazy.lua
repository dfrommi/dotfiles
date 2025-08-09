return {
  {
    "LazyVim/LazyVim",
    opts = {
      --colorscheme = "catppuccin-mocha",
      --colorscheme = "catppuccin-latte",
      colorscheme = os.getenv("OS_APPEARANCE") == "dark" and "catppuccin-mocha" or "catppuccin-latte",
      defaults = {
        --autocmds = true, -- lazyvim.config.autocmds
        --keymaps = false, -- lazyvim.config.keymaps
        --options = true, -- lazyvim.config.options
      },
    },
  },
}
