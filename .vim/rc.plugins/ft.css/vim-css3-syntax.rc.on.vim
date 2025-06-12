if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '1fc1ff5799726011fb70fa7f51435b9ca867d1b6', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

