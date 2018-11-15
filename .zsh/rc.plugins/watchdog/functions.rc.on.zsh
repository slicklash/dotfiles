function wrestart(){
  if [ -z "$1" ]; then
    echo "Usage: $0 [-d <directory>] [-p <pattern>] <command>"
  else
    zparseopts -D -E -A args -- d: p:
    dir=${args[-d]:-"."}
    pattern=${args[-p]:-"*"}
    cmd=$@
    echo $cmd
    watchmedo auto-restart --recursive --ignore-directories --directory ${dir} --patterns ${pattern} ${cmd}
  fi
}

function wdo(){
  if [ -z "$1" ]; then
    echo "Usage: $0 [-p <pattern>] <command>"
  else
    zparseopts -D -E -A args -- d: p:
    pattern=${args[-p]:-"*"}
    cmd=$@
    echo $cmd
    watchmedo shell-command --recursive --ignore-directories --patterns ${pattern} --command='${cmd}' .
  fi
}
