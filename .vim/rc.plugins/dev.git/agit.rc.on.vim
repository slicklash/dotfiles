if InitStep() == 0
  call dein#add('cohama/agit.vim', { 'rev': '8b168d347bc746f772ac99e461099ca20ff12582' })
  finish
endif

nnoremap <silent> <leader>gh :Agit<CR>
