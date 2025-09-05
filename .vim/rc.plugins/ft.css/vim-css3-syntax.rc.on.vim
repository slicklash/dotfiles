if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '2fb65e8ac32c9ac53d1a40ebe0efef0b78eb38a8', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

