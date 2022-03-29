if InitStep() == 0
  call dein#add('ntpeters/vim-better-whitespace', { 'rev': 'c5afbe91d29c5e3be81d5125ddcdc276fd1f1322' })
  finish
endif

let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help']
autocmd FileType unite DisableWhitespace
autocmd FileType vimfiler DisableWhitespace
