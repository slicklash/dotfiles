if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '3719ffddb5e42bf67b55b2183d7a6fb8d3e5a2b8', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
