if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'd858def9c13c93b59752ed0f85030d8e66fba0ac', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

