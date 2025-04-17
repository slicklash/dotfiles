if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '23ec97521148d1866bc05bbc50d7758ed0a4d84e' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
