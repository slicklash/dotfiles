function cbfile {
  [[ "$#" != 1  ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | xsel --clipboard --input
}

function cbdir {
  pwd | tr -d "\r\n" | xsel --clipboard --input
}

function gi() { curl https://www.gitignore.io/api/$@ ; }

_gitignireio_get_command_list() {
  curl -s https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignireio () {
  compset -P '*,'
  compadd -S '' `_gitignireio_get_command_list`
}

compdef _gitignireio gi
