function gco(){
  if [ -z "$1" ]; then
    git checkout "$(git branch | fzf | tr -d '[:space:]')"
  else
    git checkout $@
  fi
}

function ga(){
  if [ -z "$1" ]; then
    git ls-files -m -o --exclude-standard | fzf -m --reverse --print0 | xargs -0 -o -t git add
  else
    git add $@
  fi
}

function da(){
  if [ -z "$1" ]; then
    dotfiles diff --name-only --diff-filter=M | sed s#^#$HOME/# | fzf -m --reverse --print0 | xargs -0 -o -t dotfiles add
  else
    dotfiles add $@
  fi
}

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
