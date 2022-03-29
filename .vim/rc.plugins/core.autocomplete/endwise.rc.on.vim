if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '8faf48b69b04af120e162ce113ea21eac322e3b4', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
