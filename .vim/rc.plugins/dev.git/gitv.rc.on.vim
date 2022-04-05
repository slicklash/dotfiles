if InitStep() == 0
  call dein#add('junegunn/gv.vim', {'rev': '386d770e916dd680d1d622e715b9eb3a77f21bd1', 'depends':['tpope/vim-fugitive'] })
  finish
endif
