if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
