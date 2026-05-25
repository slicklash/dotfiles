call dein#add('hail2u/vim-css3-syntax', { 'rev': 'e84da152abaacc7a3d10d5b23b3f782782e1d6f6', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

