if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '8de7694c0aeda253073098bbc9fb890b2902ddb8', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
