if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': 'eab530110d7a0d985902a3964894816b50dbf31a', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
