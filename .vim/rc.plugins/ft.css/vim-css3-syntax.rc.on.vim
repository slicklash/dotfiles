call dein#add('hail2u/vim-css3-syntax', { 'rev': '8c8635778b8eba441fa8d5aa0ab77c7be0eeefb8', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

