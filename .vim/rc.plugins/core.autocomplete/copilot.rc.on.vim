if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '5015939f131627a6a332c9e3ecad9a7cb4c2e549' })
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
