function jdk -a jdk_version
  set -x JAVA_HOME (/usr/libexec/java_home -v $jdk_version); and java -version
end