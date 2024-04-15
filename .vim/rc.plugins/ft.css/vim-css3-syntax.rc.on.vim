if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '44dd2e6bada1a48f6697ec1596cfe5a1386418b3', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

