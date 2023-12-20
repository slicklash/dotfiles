if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '5d6990e4fc5b3e3b88a3af90146f2561c4f6d828', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
