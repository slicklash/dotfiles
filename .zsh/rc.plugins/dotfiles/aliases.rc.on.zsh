compdef dotfiles=git

alias dotfiles='/usr/bin/git --git-dir=$HOME/.git-dotfiles/ --work-tree=$HOME'
alias dvim='GIT_DIR=$HOME/.git-dotfiles GIT_WORK_TREE=$HOME vim'

alias ds='dotfiles status'
alias dss='dotfiles status -s'

alias dls='dotfiles ls-files'
alias dlsm='dotfiles ls-files -r master'
alias dlso='dotfiles ls-files --others --exclude-standard'

alias ddiff='dotfiles diff'
alias ddiffc='dotfiles diff --cached'
alias ddt='dotfiles difftool -y'
alias ddtvim='ddt --tool=vimdiff'
alias ddtcode='ddt --tool=code'

alias dch='dotfiles show --stat'

alias dg='dotfiles pull --rebase'
alias dpl='dotfiles pull'
alias dp='dotfiles push'

alias da='dotfiles add'
alias dad='dotfiles add'
alias dau='dotfiles add -u'

alias dco='dotfiles checkout'
alias dco_ma='dotfiles checkout master'
alias dreset='dotfiles reset HEAD'

alias dk='dotfiles commit -v'
alias dkm='dotfiles commit -v -m'
alias dam='dotfiles commit --amend'

alias dst='dotfiles stash'
alias dpop='dotfiles stash pop'

alias db='dotfiles branch'
alias dbr='dotfiles branch'

alias dm='dotfiles merge'
alias dmt='dotfiles mergetool'
alias drbc='dotfiles rebase --continue'
alias drba='dotfiles rebase --abort'

alias dbl='dotfiles blame -b -w'

format1='%C(yellow)%h %C(bold blue)%>(12,trunc)%cr%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'
format2='%C(yellow)%h %C(bold blue)%cd%Creset %C(red)%d%Creset %s %C(bold black)%an%Creset'

alias dlogg='dotfiles log --graph --abbrev-commit'
alias dlogf='dlogg --pretty=format:'\'$format1\'' '
alias dlogd='dlogg --date=short --pretty=format:'\'$format2\'' '
alias dlog='dlogf'
alias dloga='dlog --all'
alias dlogs='dotfiles log --stat'

alias dconf='dotfiles config'
alias dgconf='dotfiles config --global'

function dlsd() {
  dls | cut -d '/' -f 1 | uniq | xargs ls -dl --color=auto
}
