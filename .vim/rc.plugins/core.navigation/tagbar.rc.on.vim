if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': 'ccee72f1d1ed71a001e57592bd585ae77c5f83b2', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
