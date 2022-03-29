if InitStep() == 0
  call dein#add('tomtom/tcomment_vim', { 'rev': '3729ae43318faca94b0a1e878f9c6717b171d55e' })
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
