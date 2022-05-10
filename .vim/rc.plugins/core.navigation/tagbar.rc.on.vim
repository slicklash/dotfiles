if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': 'a577ee4d650476243d91698f2d1228819c5fa0a5', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
