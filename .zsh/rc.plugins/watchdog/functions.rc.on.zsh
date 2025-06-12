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

function wdo() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: wdo [-p <pattern>] <command>"
    return 1
  fi

  local pattern="*"
  local cmd=()
  local i=1

  while (( i <= $# )); do
    case "${(P)i}" in
      -p)
        (( i++ ))
        pattern="${(P)i}"
        ;;
      *)
        cmd+=("${(P)i}")
        ;;
    esac
    (( i++ ))
  done

  if [[ ${#cmd[@]} -eq 0 ]]; then
    echo "Error: No command provided."
    return 1
  fi

  echo "Watching for pattern: $pattern"
  echo "Command to run: ${cmd[@]}"

  watchmedo shell-command \
    --recursive \
    --ignore-directories \
    --patterns="$pattern" \
    --command="${cmd[@]}" \
    .
}
