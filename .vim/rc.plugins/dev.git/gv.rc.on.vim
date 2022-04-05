if InitStep() == 0
  call dein#add('gregsexton/gitv', {'rev': 'a73599c34202709eaa7da78f4fe32b97c6ef83f8', 'depends':['tpope/vim-fugitive'], 'on_cmd': 'Gitv' })
  finish
endif

nnoremap <silent> <leader>gv :Gitv<CR>
nnoremap <silent> <leader>gV :Gitv!<CR>
