if InitStep() == 0
  call dein#add('tomtom/tcomment_vim', { 'rev': 'e77e1bf61b4f1ddc7b13c6160b7389df42aba24d' })
  finish
endif

noremap <leader>u :TComment<CR>
noremap <leader>k :TComment<CR>
