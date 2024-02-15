if InitStep() == 0
  call dein#add('majutsushi/tagbar', { 'rev': '12edcb59449b335555652898f82dd6d5c59d519a', 'on_cmd' : 'TagbarToggle' })
  finish
endif

let g:tagbar_compact = 1
" toggle Tagbar
nnoremap <leader>tt <Esc>:TagbarToggle<CR><Esc>
