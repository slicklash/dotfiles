if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': 'ff52ed9296715988fc3269b64a903415c3bdf322' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
