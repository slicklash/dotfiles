call dein#add('hail2u/vim-css3-syntax', { 'rev': 'd990a6731db56df60a69a61b3fc92ee9b7c6a683', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

