call dein#add('hail2u/vim-css3-syntax', { 'rev': '0c76bef1bf28f2b3bd0f642e5960b66e5b08c18d', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

