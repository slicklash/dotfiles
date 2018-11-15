if InitStep() == 0
  call dein#add('Shougo/unite-outline')
  finish
elseif !dein#tap('unite.vim')
  finish
endif

nnoremap <silent> <Space>o :Unite outline<CR>
