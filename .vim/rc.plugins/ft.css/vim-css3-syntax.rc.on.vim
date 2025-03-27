if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'b0bc65e6f836e39fee5e064b698d0da4256676f7', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

