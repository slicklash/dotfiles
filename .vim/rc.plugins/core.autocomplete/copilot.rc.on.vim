if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': 'da369d90cfd6c396b1d0ec259836a1c7222fb2ea' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:false,
\ 'css': v:false,
\ 'java': v:false,
\ 'go': v:false,
\ 'javascript': v:false,
\ 'nim': v:true,
\ 'python': v:true,
\ 'robo1': v:false,
\ 'shell': v:false,
\ 'typescript': v:true,
\ 'make': v:false,
\}
