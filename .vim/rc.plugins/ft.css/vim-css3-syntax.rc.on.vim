if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '9a24ae3c6f8353c95057c595d9008e85daa85e95', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

