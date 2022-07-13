if InitStep() == 0
  call dein#add('ntpeters/vim-better-whitespace', { 'rev': '1b22dc57a2751c7afbc6025a7da39b7c22db635d' })
  finish
endif

let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help']
autocmd FileType unite DisableWhitespace
autocmd FileType vimfiler DisableWhitespace
