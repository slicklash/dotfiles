if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '4268535e1d33117a680a91160d845cd3833dfe28' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
