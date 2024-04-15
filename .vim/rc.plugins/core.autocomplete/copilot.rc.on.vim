if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '1e135c5303bc60598f6314a2276f31dc91aa34dd' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
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
