if InitStep() == 0
  call dein#add('justinmk/vim-sneak', { 'rev': 'c13d0497139b8796ff9c44ddb9bc0dc9770ad2dd' })
  let g:sneak#streak = 1
  finish
endif

