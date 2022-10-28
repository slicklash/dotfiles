color="white"
if [ "$USER" = "root" ]; then
  color="red"
fi;

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_pyenv() {
  if [[ -n $PYENV_SHELL ]]; then
    local version
    version=${(@)$(pyenv version)[1]}
    if [[ $version != system ]]; then
      prompt_segment black 240 "pyenv:$version"
    fi
  fi
}

RPROMPT='$(prompt_pyenv)'

setopt prompt_subst
PROMPT='%B%F{blue}%~ %b%F{green}$(git_info) %B%F{yellow}$(git_modified_sign)%f%k%b
%F{$color}%# %b%f'
