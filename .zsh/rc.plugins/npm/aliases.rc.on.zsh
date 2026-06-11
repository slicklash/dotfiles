alias n='npm'

alias ni="n install --no-package-lock"

alias nls="n ls --depth=0"

alias ns="n start"

alias nt="n run test"
alias ntd="nt -- --inspect-brk"
alias ntw="nt -- --watch"
alias ntc="n run test:client"
alias nts="n run test:server"
alias nte="n run test:e2e"
alias ntu="n run test:unit"

alias njest="npx jest"
alias nlint="npx eslint"

export TURBO_CONCURRENCY=2

alias y='yarn'
alias ys='y start'
alias yb='y build'
alias yf='y format'
alias yl='y lint'
alias ya='y audit'
alias ytu='y run test:unit'

alias p='pnpm'
alias pb='p build'
alias pf='p format'
alias pl='p lint'
