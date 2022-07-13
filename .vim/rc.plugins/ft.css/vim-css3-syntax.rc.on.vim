if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '2cbb2ddada6856a5f291b1631b1712d407b0c7c7', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

