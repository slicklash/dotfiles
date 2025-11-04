if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '7bfffca1f121afb7a9e38747500bf5270e006bb1', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
