if InitStep() == 0
  call dein#add('wellle/tmux-complete.vim')
  finish
endif

let g:tmuxcomplete#trigger = ''
