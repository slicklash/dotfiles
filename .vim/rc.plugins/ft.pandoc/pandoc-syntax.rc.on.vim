if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '2baeabb9584bb948618806f22bc4cef5685535fc' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
