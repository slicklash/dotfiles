function git_info() {
  local br
  br=$(git_branch_name)
  if [[ $br ]]; then
    echo "$br"
  fi
}

function git_branch_name() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo "${ref#refs/heads/}"
}

function git_modified_sign() {
  local st
  st=$(command git status --porcelain 2> /dev/null | tail -n1)
  if [[ -n $st ]]; then
    echo "*"
  fi
}
