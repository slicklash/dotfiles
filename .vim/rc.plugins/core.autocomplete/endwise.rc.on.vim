if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '1d42c830d8a81958a6703cee8f4caece4b1b8423', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
