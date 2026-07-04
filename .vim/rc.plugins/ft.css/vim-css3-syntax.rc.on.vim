call dein#add('hail2u/vim-css3-syntax', { 'rev': '0968a360f085a083f21f80d57a460cad8f59dd2c', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

