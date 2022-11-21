if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '6c3e15ea4a1ef9619c248c2b1eced56a47b61a9e', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
