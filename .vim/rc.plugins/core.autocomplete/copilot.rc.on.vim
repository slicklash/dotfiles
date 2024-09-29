if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '782461159655b259cff10ecff05efa761e3d4764' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:true,
\ 'css': v:true,
\ 'java': v:true,
\ 'javascript': v:false,
\ 'nim': v:false,
\ 'python': v:true,
\ 'robo1': v:true,
\ 'shell': v:true,
\ 'typescript': v:false,
\ 'make': v:true,
\}
