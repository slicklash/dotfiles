if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '0243b19920a683df531f19bb7fb80c0ff83927dd', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
