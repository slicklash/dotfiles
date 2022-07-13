if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '79a3397f7799cb211a7fb803388b96a5f28fd778', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
