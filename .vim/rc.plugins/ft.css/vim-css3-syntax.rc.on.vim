if InitStep() == 0
  call dein#add('hail2u/vim-css3-syntax', { 'rev': 'f99c2ee07e6f9bf35ebe5019b846c435439fb974', 'on_ft': ['css','scss','sass'] })
  finish
endif

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

