if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '315c6d2b16e018cb8020f20aaa7081ebc4070828' })
  finish
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'css': v:true,
\ 'java': v:true,
\ 'javascript': v:false,
\ 'nim': v:true,
\ 'python': v:true,
\ 'robo1': v:true,
\ 'shell': v:true,
\ 'typescript': v:true,
\ 'vim': v:true,
\}
