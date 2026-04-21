call dein#add('hail2u/vim-css3-syntax', { 'rev': 'cd85b1ff4f65e9572c473869e08e2bb4f34a94c3', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

