if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '2ef4ecba94440fcf8a8c692a0f2b36b332f1f0f2', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
