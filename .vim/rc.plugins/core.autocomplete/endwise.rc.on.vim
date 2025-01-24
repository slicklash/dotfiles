if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '5ec72eef1a07fb32af9be5402144678f68cb1a7a', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
