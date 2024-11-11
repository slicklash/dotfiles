if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '87038123804796ca7af20d1b71c3428d858a9124' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:true,
\ 'css': v:true,
\ 'java': v:true,
\ 'go': v:true,
\ 'javascript': v:false,
\ 'nim': v:false,
\ 'python': v:true,
\ 'robo1': v:true,
\ 'shell': v:true,
\ 'typescript': v:false,
\ 'make': v:true,
\}
