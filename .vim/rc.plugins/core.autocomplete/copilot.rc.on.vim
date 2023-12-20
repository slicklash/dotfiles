if InitStep() == 0
  call dein#add('github/copilot.vim', { 'rev': '5b19fb001d7f31c4c7c5556d7a97b243bd29f45f' })
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
