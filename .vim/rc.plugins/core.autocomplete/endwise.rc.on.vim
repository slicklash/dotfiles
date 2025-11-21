if InitStep() == 0
  call dein#add('tpope/vim-endwise', { 'rev': '4994afb0cdf956d9a665a14b9c834869e602c396', 'on_ft': ['lua', 'sh', 'vim', 'zsh'] })
  finish
endif
