if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '43301cf9a0fafd78cec7c2e5b9c0e2cfd9436e8a', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
