function gradle -d 'wrapper to use gradlew from subdirectories'
    if set -l gradlew (find_up gradlew)
        eval $gradlew $argv
    else
        return 128
    end
end
