function fish_user_key_bindings
  bind \e\[1\;10D cd_git_root

  # FZF
  bind \cf '__fzf_find_file'
  bind \cr '__fzf_reverse_isearch'
  bind \ex '__fzf_find_and_execute'
  bind \ed '__fzf_cd'
  bind \eD '__fzf_cd_with_hidden'

  # Touchbar
  bind -k f2 'touchbar_directory_callback'
end
