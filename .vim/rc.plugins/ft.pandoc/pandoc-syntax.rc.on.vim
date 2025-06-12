if InitStep() == 0
  call dein#add('vim-pandoc/vim-pandoc-syntax', { 'rev': 'ea3fc415784bdcbae7f0093b80070ca4ff9e44c8' })
  finish
endif

let g:pandoc#syntax#conceal#use = 0
