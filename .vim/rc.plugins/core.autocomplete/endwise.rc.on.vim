if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '4ed852d137853a0c242846fd0a61a241b4c7b467', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
