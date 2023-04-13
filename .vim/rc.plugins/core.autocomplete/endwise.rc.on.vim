if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': 'c3411c95290063f56dfe13b485882111ef403c6e', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
