function _git_stash_select() {
  echo $(git stash list | fzf --ansi --no-sort --reverse --preview="echo {} | cut -d':' -f1 | xargs git stash show -p | bat --color=always -p"  | cut -d ':' -f1)
}

function gpop(){
  local ref=$(_git_stash_select)
  if [ ! -z "$ref" ]; then
    git stash pop $ref
  fi
}

function gdrop(){
  local ref=$(_git_stash_select)
  if [ ! -z "$ref" ]; then
    git stash drop $ref
  fi
}

function gstp(){
  if [ -z "$1" ]; then
    local files=`git ls-files -m $(git rev-parse --show-toplevel)`
    if [ -z "$files" ]; then
      return
    fi
    files=$(echo $files | fzf -m --reverse --print0)
    if [ ! -z "$files" ]; then
      git stash push $(echo $files | tr '\000' '\040')
    fi
  else
    git stash push $@
  fi
}

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

function gr(){
  if [ -z "$1" ]; then
    git ls-files -m | fzf -m --reverse --print0 | xargs -0 -o -t git restore
  else
    git restore $@
  fi
}

function dr(){
  if [ -z "$1" ]; then
    dotfiles ls-files -m | fzf -m --reverse --print0 | xargs -0 -o -t dotfiles restore
  else
    dotfiles restore $@
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

function gl () {
  if [[ ! `git log -n 1 $@ | head -n 1` ]] ;then
    return
  fi

  local format='%C(yellow)%h %C(bold blue)%>(12,trunc)%cr%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'
  local gitlog=(
    git log
    --color=always
    --abbrev=7
    --format=$format1
  )

  local fzf=(
    fzf
    --ansi --no-sort --reverse --tiebreak=index
    --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always $@ \$1; }; f {}"
    --bind "ctrl-q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
   --preview-window=right:60%
  )

  $gitlog | $fzf
}
