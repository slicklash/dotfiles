if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '25feddf8e3aa79f0573c8f43ddb13c44c530cfa5' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:true,
\ 'css': v:true,
\ 'java': v:true,
\ 'javascript': v:true,
\ 'nim': v:true,
\ 'python': v:true,
\ 'robo1': v:true,
\ 'shell': v:true,
\ 'typescript': v:true,
\ 'make': v:true,
\}
