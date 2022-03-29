if InitStep() == 0
  call dein#add('junegunn/gv.vim', {'rev': 'a73599c34202709eaa7da78f4fe32b97c6ef83f8', 'depends':['tpope/vim-fugitive'] })
  finish
endif
