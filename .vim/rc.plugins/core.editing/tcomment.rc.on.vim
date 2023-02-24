if InitStep() == 0
  call dein#add('tomtom/tcomment_vim', { 'rev': 'b4930f9da28647e5417d462c341013f88184be7e' })
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
