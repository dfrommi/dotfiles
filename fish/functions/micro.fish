function micro
  set -l touchbar_name micro_(random)
  if touchbar_available
    echo -ne "\033]1337;PushKeyLabels=$touchbar_name\a"
    echo -ne "\033]1337;SetKeyLabel=F1=❔\a"
    echo -ne "\033]1337;SetKeyLabel=F2=💾🚪\a"
    echo -ne "\033]1337;SetKeyLabel=F3=🔍\a"
    echo -ne "\033]1337;SetKeyLabel=F4=🚪\a"
  end

  command micro $argv

  if touchbar_available
    echo -ne "\033]1337;PopKeyLabels=$touchbar_name\a"
  end
end
