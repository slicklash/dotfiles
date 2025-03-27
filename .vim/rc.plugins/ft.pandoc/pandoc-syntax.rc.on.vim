if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '05ef7f44ebaea37159db8d365058c0a9e2ef14b5' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
