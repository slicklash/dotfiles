if InitStep() == 0
  call dein#add('tomtom/tcomment_vim', { 'rev': '90eaf759099bcd47aa0471f974109d7fd78e4eea' })
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
