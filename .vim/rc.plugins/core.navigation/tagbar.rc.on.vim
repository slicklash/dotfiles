if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '1d22809dbe4cd8b833ec4359e53bd843fd29de47', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
