if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': '7bea0ba8929749b2a471520af87635163fb28bdf' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
