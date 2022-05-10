if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '87283273b0cd2dded5ee0b629032f9a137e7eec5', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

