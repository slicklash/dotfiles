export ZSH_PLUGINS_ALIAS_TIPS_TEXT="tip: "
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="_ c vi"
export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1

alias ..='cd ..'

alias ls='ls -FG --color'
alias l='ls'
alias ll='l -l'
alias l.='l -a'
alias la='l -al'
alias ll.='la'

alias lsbig='ls -lhS'
alias lssmall='ls -lhSr'
alias lsnew='ls -lhtr'
alias lsold='ls -lht'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

autoload -U zmv
alias mmv='noglob zmv -W'

alias vi='vim'
alias vin='vim -u NONE'
alias vx='vim -c Vinarise'

alias tmux='tmux -2'

alias notes='notebook.py'

alias wrestart='watchmedo auto-restart'

# alias pu='portsnap fetch update'
# alias pv='portversion | grep "<"'

case "$OSTYPE" in
  linux-android*)
    alias pbcopy='termux-clipboard-set'
    alias pbpaste='termux-clipboard-get'
    ;;
  linux*)
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    alias open='xdg-open'
    ;;
esac

alias o='open'

alias exclude_jsconfig='echo "jsconfig.json" >> .git/info/exclude'

alias ndebug-jest="node --inspect-brk node_modules/.bin/jest --runInBand"

alias kill-docker='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias rgni='rg --no-ignore'
alias klr='killall redis-server'
alias kln='killall turbo || killall node'

alias taoc='tmux-workspace code code/aoc22'
alias lf='lfub'
