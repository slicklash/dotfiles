if InitStep() == 0
  call dein#add('wellle/tmux-complete.vim', { 'rev': '87f6f96c73b599554d1d7f313413d7f9d0336096' })
  finish
endif

let g:tmuxcomplete#trigger = ''
