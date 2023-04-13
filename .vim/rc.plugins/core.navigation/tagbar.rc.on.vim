if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': 'be563539754b7af22bbe842ef217d4463f73468c', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
