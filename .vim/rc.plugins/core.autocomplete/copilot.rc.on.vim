if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': 'a9228e015528c9307890c48083c925eb98a64a79' })
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
