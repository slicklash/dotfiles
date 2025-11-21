if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': 'f89e977c87180519ba3b942200e3d05b17b1e2fc' })
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
