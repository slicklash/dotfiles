call dein#add('hail2u/vim-css3-syntax', { 'rev': '3b2d6ef0b1c0548451cbc6ce7fcbd84f7031a4a4', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

