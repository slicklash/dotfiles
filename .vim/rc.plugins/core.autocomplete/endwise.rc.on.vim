if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '720b3ee46a86fe8858baeed473e11bca54b997a9', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
