call dein#add('hail2u/vim-css3-syntax', { 'rev': '2dc629853c1dcc3b87a63fe399813e99aca807b4', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

