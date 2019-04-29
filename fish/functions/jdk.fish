function jdk -a version
  set -x JAVA_HOME (/usr/libexec/java_home -v $version); and java -version
end