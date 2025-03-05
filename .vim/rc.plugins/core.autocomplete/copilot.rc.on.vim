if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': 'cd7f01009fb7b30e22840cadc4faad88b05c6eef' })
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
