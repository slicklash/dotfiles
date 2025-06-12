if InitStep() == 0
  call dein#add('ntpeters/vim-better-whitespace', { 'rev': 'de99b55a6fe8c96a69f9376f16b1d5d627a56e81' })
  finish
endif

let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help']
autocmd FileType unite DisableWhitespace
autocmd FileType vimfiler DisableWhitespace
