if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': 'e714ac3bcfd5a90038de49c3254eded7c70ae3c3', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
