if InitStep() == 0
  call dein#add('justinmk/vim-sneak', { 'rev': '18b1faf020e6a66c1ce09b3ff5e6b6feb182973b' })
  let g:sneak#streak = 1
  finish
endif

