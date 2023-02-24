function dexec(){
  docker exec -it $@
}

function drm() {
  if [ -z "$1" ]; then
    echo "docker rm <name>"
    exit 0
  fi
  local id=$(docker ps -a | grep "$1" | cut -d ' ' -f 1)
  if [ -n "$id" ]; then
    docker rm -f $id
  fi
}
