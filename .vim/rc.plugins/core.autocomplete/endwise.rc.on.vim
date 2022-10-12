if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '4e5c8358d751625bb040b187b9fe430c2b769f0a', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
