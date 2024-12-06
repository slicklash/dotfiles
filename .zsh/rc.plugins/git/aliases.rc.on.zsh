alias gs='git status'
alias gss='git status -s'

alias gls='git ls-files'
alias glsm='git ls-files -r master'
alias glso='git ls-files --others --exclude-standard'

alias gdiff='git diff'
alias gdiffc='git diff --cached'
alias gdiffm='git diff master'
alias gdt='git difftool -y'
alias gdiffnames='git diff --name-status'
alias gdtvim='gdt --tool=vimdiff'
alias gdtcode='gdt --tool=code'

alias gch='git show --stat'

alias gg='git pull --rebase'
alias gpl='git pull'
alias gp='git push'
alias gpu='gp -u origin "$(git rev-parse --abbrev-ref HEAD)"'

alias gau='git add -u'

alias gco_m='git checkout main'
alias gco_ma='git checkout master'
alias greset='git reset HEAD'
alias greset_last='git reset HEAD~'

alias gk='git commit -v'
alias gkm='git commit -v -m'
alias gam='git commit --amend'

alias gst='git stash'

alias gb='git branch'
alias gbr='git branch'

alias gm='git merge'
alias gmt='git mergetool'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

alias gbl='git blame -b -w'

format1='%C(yellow)%h %C(bold blue)%>(12,trunc)%cr%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'
format2='%C(yellow)%h %C(bold blue)%cd%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'

alias glogg='git log --graph --abbrev-commit'
alias glogf='glogg --pretty=format:'\'$format1\'' '
alias glogd='glogg --date=short --pretty=format:'\'$format2\'' '
alias glog='glogf'
alias glogm='glog origin/master..HEAD'
alias gloga='glog --all'
alias glogs='git log --stat'
alias glogt='git log --tags --simplify-by-decoration --pretty="format:%ai %d"'

alias gconf='git config'
alias ggconf='git config --global'
