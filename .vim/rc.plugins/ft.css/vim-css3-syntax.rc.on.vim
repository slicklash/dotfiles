call dein#add('hail2u/vim-css3-syntax', { 'rev': 'f92f5141a86598964da8afd772be553a016f9df5', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

