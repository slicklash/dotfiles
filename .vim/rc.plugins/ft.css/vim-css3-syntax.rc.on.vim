if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '61bc815f2b33f38a132e2e3aa3846d9b092ad931', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

