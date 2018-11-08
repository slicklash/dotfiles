if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax')
  finish
endif

let g:pandoc#syntax#conceal#use = 0
