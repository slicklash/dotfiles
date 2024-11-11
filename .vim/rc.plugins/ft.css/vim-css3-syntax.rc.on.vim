if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': '089f388a9eb97336b7069b071ffdcab63ad54b95', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

