if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '5e090da54bf999c657608b6c8ec841ef968d923d', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
