if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'b7778bc2094f2ab99046ce1176c503d9acb7a0bb', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

