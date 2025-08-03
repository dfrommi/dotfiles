function theme_mode -d "Switch between dark and light theme" --argument mode

    if test "$mode" != light -a "$mode" != dark
        echo "Usage: theme_mode [light|dark]"
        return 1
    end

    # if test "$mode" = "$OS_APPEARANCE"
    #     echo "Theme already $mode"
    #     return
    # end

    set -Ux OS_APPEARANCE $mode

    sed -i '' "s/^palette = \".*\"/palette = \"$mode\"/" ~/.config/starship.toml

    #TODO: make this work
    # - fish_config theme choose "Catppuccin ..."
    # - default them fallback on startup
    if test "$mode" = dark
        yes | fish_config theme save "Catppuccin Mocha"

        sed -i '' "s/^set -g @catppuccin_flavor \".*\"/set -g @catppuccin_flavor \"mocha\"/" ~/.config/tmux/catppuccin.conf

        set -Ux BAT_THEME Catppuccin-mocha
        set -Ux LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/thirdparty/lazygit-catppuccin/themes-mergable/mocha/sky.yml"
        set -Ux FZF_DEFAULT_OPTS "\
          --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
          --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
          --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    else
        yes | fish_config theme save "Catppuccin Latte"

        sed -i '' "s/^set -g @catppuccin_flavor \".*\"/set -g @catppuccin_flavor \"latte\"/" ~/.config/tmux/catppuccin.conf

        set -Ux BAT_THEME Catppuccin-latte
        set -Ux LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/thirdparty/lazygit-catppuccin/themes-mergable/latte/sky.yml"
        set -Ux FZF_DEFAULT_OPTS "\
          --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
          --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
          --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
          --color=selected-bg:#BCC0CC \
          --color=border:#CCD0DA,label:#4C4F69"
    end

    #tmux source-file ~/.config/tmux/tmux.conf
end
