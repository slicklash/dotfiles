alias npmpublic="npm config set registry https://registry.npmjs.org/"
alias npmprivate="npm config set registry http://npm.dev.wixpress.com"
alias n='npm'
alias np="npm --registry=https://registry.npmjs.org/"
alias ni="n install --no-package-lock"
alias nip='ni --registry=https://registry.npmjs.org/'
alias nls="n ls --depth=0"
alias npls="np ls --depth=0"

alias ns="n start"
alias nt="n run test:client"
alias ntd="nt -- --inspect-brk"
alias nts="n run test:server"
alias nte="n run test:e2e"
alias ntu="n run test:unit"
alias ntw="nt -- --watch"
alias nyoshi="npx yoshi"
alias njest="npx jest"
alias nmocha="npx mocha"
alias cmocha="npx nyc -r html mocha"
alias neslint="npx eslint"
alias find-pkg-locks='find . -name "package-lock.json" -not -path "*/node_modules/*"'
