if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '16939cda184ff555938cc895cc62477c172997f9' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
