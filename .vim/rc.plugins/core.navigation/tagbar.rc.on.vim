if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': 'd55d454bd3d5b027ebf0e8c75b8f88e4eddad8d8', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
