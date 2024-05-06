[.[] | select(.is_focused == true) | .tabs[] |
  {
    label: (.title | split(" • ")[1]),
    icon: (.title | split(" • ")[0]),
    drawing: "on", 
    "label.color": (if .is_active then "0xff8aadf4" else "0xff939ab7" end), 
    "icon.color": (if .is_active then "0xffcad3f5" else "0xff939ab7" end)
  }
] as $tabs |

[range(1;10) as $i | 
  $tabs[$i-1] | 
  "--set tab." + ($i|tostring) + " " + 
  if .label then
    (to_entries | map("\(.key)='\(.value)'") | join(" "))
  else
    "drawing='off'"
  end
] | join(" ")

