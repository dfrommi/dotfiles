function owm
  command curl -s "http://pro.openweathermap.org/data/2.5/group?APPID=$OWM_APP_ID&units=metric&id=$argv"
end
