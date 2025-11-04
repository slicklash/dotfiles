if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'de15898a873478ade739d333ba42cf9b065a464c', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

