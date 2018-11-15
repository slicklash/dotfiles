if InitStep() == 0
  call dein#add('gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'on_cmd': 'Gitv' })
  finish
endif

nnoremap <silent> <leader>gv :Gitv<CR>
nnoremap <silent> <leader>gV :Gitv!<CR>
