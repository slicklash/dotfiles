if InitStep() == 0
  call dein#add('ntpeters/vim-better-whitespace', { 'rev': '86a0579b330b133b8181b8e088943e81c26a809e' })
  finish
endif

let g:better_whitespace_filetypes_blacklist=['diff', 'qf', 'gitcommit', 'unite', 'vimfiler', 'help']
autocmd FileType unite DisableWhitespace
autocmd FileType vimfiler DisableWhitespace
