if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': 'f6a32fbe4d4e511d446ac189e926f8e24f69cc1e', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
