if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'd8ad25fdb64e762fb79c693ab574acfc17116aa7', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

