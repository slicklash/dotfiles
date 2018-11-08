if InitStep() == 0
    call dein#add('junegunn/gv.vim', {'depends':['tpope/vim-fugitive'] })
    finish
endif
