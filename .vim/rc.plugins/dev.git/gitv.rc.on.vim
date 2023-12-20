if InitStep() == 0
  call dein#add('junegunn/gv.vim', {'rev': 'b6bb6664e2c95aa584059f195eb3a9f3cb133994', 'depends':['tpope/vim-fugitive'] })
  finish
endif
