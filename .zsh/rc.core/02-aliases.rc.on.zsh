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

alias tmux='tmux -2'

alias notes='notebook.py'

alias wrestart='watchmedo auto-restart'

alias pu='portsnap fetch update'
alias pv='portversion | grep "<"'

# alias pbcopy='xsel --clipboard --input'
# alias pbpaste='xsel --clipboard --output'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias exclude_jsconfig='echo "jsconfig.json" >> .git/info/exclude'

alias comdep="cat package.json | grep '^\s*\"communities-' | sed 's/^.*\"\(communities-[^\"]\+\).*/\1/' | sort | tr '\n' ' '"
alias lblog="npm link communities-api-middleware communities-blog-external-contracts communities-blog-proto communities-blog-rce communities-blog-translations communities-common-services communities-common-testing communities-image-lib communities-notifications-service-testkit communities-storage communities-tpa-provision-handler communities-universal communities-user-service-client communities-viewer-keep-alive communities-window-resize"
alias lforum="npm link communities-api-middleware communities-common-services communities-storage communities-tpa-provision-handler communities-translations communities-universal communities-user-service-client communities-viewer-keep-alive communities-common-testing communities-notifications-service-testkit"
alias lmembers="npm link communities-api-middleware communities-common-services communities-members-translations communities-storage communities-tpa-provision-handler communities-universal communities-user-service-client communities-viewer-keep-alive communities-notifications-service-testkit"
alias lnotifications="npm link communities-common-services communities-universal communities-viewer-keep-alive communities-notifications-service-testkit"

alias ndebug-jest="node --inspect-brk node_modules/.bin/jest --runInBand"

alias kill-blog-services='killall node || killall redis-server || killall mongod'
alias kill-docker='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias rce-versions="for x in \$(cat package.json | grep \\\"wix-rich | cut -d '\"' -f 2); do npm view \$x; done | grep versions"
alias react-versions="for x in \$(cat package.json | grep \\\"react\\\" | cut -d '\"' -f 2); do npm view \$x; done | grep versions"

alias rgni='rg --no-ignore'
