if InitStep() == 0
  call dein#add('tomtom/tcomment_vim', { 'rev': '7fb091aad8d824bef1d7bc9365921c65e26d82ad' })
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
