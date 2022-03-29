if InitStep() == 0
  call dein#add('justinmk/vim-sneak', { 'rev': '94c2de47ab301d476a2baec9ffda07367046bec9' })
  let g:sneak#streak = 1
  finish
endif

