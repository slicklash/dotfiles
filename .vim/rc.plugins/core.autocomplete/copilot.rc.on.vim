if !exists('$TERMUX_VERSION')
  call dein#add('github/copilot.vim', { 'rev': 'a12fd5672110c8aa7e3c8419e28c96943ca179be' })
endif

let g:copilot_filetypes = {
\ '*': v:false,
\ 'c': v:false,
\ 'css': v:false,
\ 'go': v:false,
\ 'java': v:false,
\ 'javascript': v:false,
\ 'make': v:false,
\ 'nim': v:false,
\ 'python': v:true,
\ 'robo1': v:false,
\ 'shell': v:false,
\ 'typescript': v:true,
\ 'vim': v:true,
\}
