function gradle -d 'wrapper to either use gradlew or gradle'
  if set -l gradlew (find_up gradlew)
    eval $gradlew $argv
  else
    command gradle $argv
  end
end
