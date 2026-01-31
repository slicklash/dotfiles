compdef dotfiles=git

alias dgit='git --git-dir=$HOME/.git-dotfiles/ --work-tree=$HOME'
alias ds='dgit status'
alias dss='dgit status -s'

alias ddiff='dgit diff'
alias ddiffc='dgit diff --cached'
alias ddt='dgit difftool -y'

alias dpl='dgit pull'
alias dp='dgit push'

alias dad='dgit add'
alias dau='dgit add -u'

alias dco='dgit checkout'
alias dco_ma='dgit checkout master'
alias dreset='dgit reset HEAD'

alias dk='dgit commit -v'
alias dkm='dgit commit -v -m'
alias dam='dgit commit --amend'

alias dst='dgit stash'
alias dpop='dgit stash pop'

alias db='dgit branch'
alias dbr='dgit branch'

alias dm='dgit merge'
alias dmt='dgit mergetool'
alias drbc='dgit rebase --continue'
alias drba='dgit rebase --abort'

alias dbl='dgit blame -b -w'

local format1='%C(yellow)%h %C(bold blue)%>(12,trunc)%cr%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'
local format2='%C(yellow)%h %C(bold blue)%cd%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'

alias dlogg='dgit log --graph --abbrev-commit'
alias dlogf='dlogg --pretty=format:'\'$format1\'' '
alias dlogd='glogg --date=short --pretty=format:'\'$format2\'' '
alias dlog='dlogf'
alias dloga='dlog --all'
alias dlogs='dgit log --stat'

alias dconf='dgit config'

function dlsd() {
  dls | cut -d '/' -f 1 | uniq | xargs ls -dl --color=auto
}
