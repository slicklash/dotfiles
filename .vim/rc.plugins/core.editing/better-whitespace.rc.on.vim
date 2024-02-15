if InitStep() == 0
  call dein#add('ntpeters/vim-better-whitespace', { 'rev': '029f35c783f1b504f9be086b9ea757a36059c846' })
  finish
endif

let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help']
autocmd FileType unite DisableWhitespace
autocmd FileType vimfiler DisableWhitespace
