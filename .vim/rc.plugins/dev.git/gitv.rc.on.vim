if InitStep() == 0
  call dein#add('junegunn/gv.vim', {'rev': '1507838ee67f9b298def89cbfc404a0fee4a4b8c', 'depends':['tpope/vim-fugitive'] })
  finish
endif
