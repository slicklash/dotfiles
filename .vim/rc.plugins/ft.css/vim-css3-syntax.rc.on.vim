call dein#add('hail2u/vim-css3-syntax', { 'rev': '52be11ebc3e536ace9db7117b4724ec07ec95016', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

