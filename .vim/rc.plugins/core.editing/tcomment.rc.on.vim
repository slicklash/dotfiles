if InitStep() == 0
  call dein#add('tomtom/tcomment_vim')
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
