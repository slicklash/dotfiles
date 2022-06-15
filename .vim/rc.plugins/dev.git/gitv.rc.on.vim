if InitStep() == 0
  call dein#add('junegunn/gv.vim', {'rev': '0d9e787246caed6c22128c05efed9e9fc65ca4cf', 'depends':['tpope/vim-fugitive'] })
  finish
endif
