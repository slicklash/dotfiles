if InitStep() == 0
  call dein#add('justinmk/vim-sneak', { 'rev': 'ed9aff2df0d503f043269180bed03c0592ccdf4d' })
  let g:sneak#streak = 1
  finish
endif

