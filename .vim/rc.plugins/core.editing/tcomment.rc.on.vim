if InitStep() == 0
  call dein#add('tomtom/tcomment_vim', { 'rev': '48ab639a461d9b8344f7fee06cb69b4374863b13' })
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
