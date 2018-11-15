if InitStep() == 0
  call dein#add('elzr/vim-json', { 'filetypes' : ['json'] })
  finish
endif

let g:vim_json_syntax_conceal = 0
