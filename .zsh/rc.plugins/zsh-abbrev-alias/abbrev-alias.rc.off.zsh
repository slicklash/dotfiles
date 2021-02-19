#!/usr/bin/env zsh

if [[ -n $ZSH_VERSION ]]; then
  fpath+=${0:A:h}/src
  autoload -Uz abbrev-alias
  abbrev-alias --init
  source ${0:A:h}/abbrev.zsh
fi
