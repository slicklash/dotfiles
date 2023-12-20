if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '3cd856659d117cd4ad097535cec8270a224643ed', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

