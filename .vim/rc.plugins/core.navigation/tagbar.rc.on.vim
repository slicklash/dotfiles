if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': 'af3ce7c3cec81f2852bdb0a0651d2485fcd01214', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
