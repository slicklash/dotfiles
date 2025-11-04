if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '87929100f2497da82f19180ffa49e75a88e7c369' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
