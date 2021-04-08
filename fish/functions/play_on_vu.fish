function play_on_vu -a url -d 'play stream on vu'
  set clean_url (echo -n "$url" | string replace -a ':' '%253a' | string replace -a '/' '%2F')

  curl "http://vusolo4k/web/mediaplayerplay?file=4097:0:1:0:0:0:0:0:0:0:$clean_url"  
end