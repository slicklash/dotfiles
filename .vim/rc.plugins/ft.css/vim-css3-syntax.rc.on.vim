if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'a6133ac2ffbfa42c6998b3154681073eb2ae16fa', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

