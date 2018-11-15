ZSH_CACHE_DIR=$HOME/.cache/zsh

[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR

export EDITOR=vim

HISTFILE=~/.history_zsh
HISTSIZE=10000
SAVEHIST=10000

setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history

setopt AUTO_CD
setopt NO_BEEP

stty stop undef
stty -ixon

autoload -U zmv
