if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '7328bcbe826fc088a7989a536f1c90aa0c82f3d1', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

