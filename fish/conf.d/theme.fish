fish_config theme choose "Catppuccin Mocha"

set -x BAT_THEME Catppuccin-mocha

set -x FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

set -x LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.cache/nvim/lazygit-theme.yml"
