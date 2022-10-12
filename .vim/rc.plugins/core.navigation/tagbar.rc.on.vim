if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '83933d557409639df53fd2ca21484279b5854c1e', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
