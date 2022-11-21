function gradle_dt(){
  if [ -z "$1" ]; then
    ./gradlew test --debug-jvm
  else
    ./gradlew test --tests $1 --debug-jvm
  fi
}

function gradle_dr(){
  ./gradlew run --debug-jvm
}
