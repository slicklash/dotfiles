if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '17a022b528b8ff328e798965a98f51324689e5f7', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

