call dein#add('hail2u/vim-css3-syntax', { 'rev': '6c0b209f7b99058afee0ae2236e9b6c21c77bed2', 'on_ft': ['css','scss','sass'] })

augroup filetype_css
  autocmd!
  autocmd FileType css,scss,sass setlocal shiftwidth=2
augroup END

