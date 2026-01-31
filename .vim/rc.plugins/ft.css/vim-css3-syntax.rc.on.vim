call dein#add('hail2u/vim-css3-syntax', { 'rev': 'f2fba9f8b2f19cdd5215567e6eef6606bf91cf11', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

