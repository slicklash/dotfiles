if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
