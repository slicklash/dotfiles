if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '87038123804796ca7af20d1b71c3428d858a9124' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:false,
\ 'css': v:false,
\ 'java': v:false,
\ 'go': v:false,
\ 'javascript': v:false,
\ 'nim': v:false,
\ 'python': v:false,
\ 'robo1': v:false,
\ 'shell': v:false,
\ 'typescript': v:true,
\ 'make': v:false,
\}
