if InitStep() == 0
  call dein#add('justinmk/vim-sneak', { 'rev': '93395f5b56eb203e4c8346766f258ac94ea81702' })
  let g:sneak#streak = 1
  finish
endif

