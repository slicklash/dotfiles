if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '50adac88c42c373ce9cfa54b9e2e225e6a159ee3', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

