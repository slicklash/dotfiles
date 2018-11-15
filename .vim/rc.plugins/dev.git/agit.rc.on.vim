if InitStep() == 0
  call dein#add('cohama/agit.vim')
  finish
endif

nnoremap <silent> <leader>gh :Agit<CR>
