if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '2137c1437012afc82b5d50404b1404aec8699f7b', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
