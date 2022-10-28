if InitStep() == 0
  call dein#add('junegunn/gv.vim', {'rev': '320cc8c477c5acc4fa0e52a460d87b2af54fa051', 'depends':['tpope/vim-fugitive'] })
  finish
endif
