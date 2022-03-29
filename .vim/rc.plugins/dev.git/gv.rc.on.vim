if InitStep() == 0
  call dein#add('gregsexton/gitv', {'rev': '386d770e916dd680d1d622e715b9eb3a77f21bd1', 'depends':['tpope/vim-fugitive'], 'on_cmd': 'Gitv' })
  finish
endif

nnoremap <silent> <leader>gv :Gitv<CR>
nnoremap <silent> <leader>gV :Gitv!<CR>
