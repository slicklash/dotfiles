if InitStep() == 0
  call dein#add('dr-chip-vim-scripts/ZoomWin', { 'rev': '38b0a76d9ccb67fd4d09807207838c8e8d9663a1' })
  finish
endif

nnoremap ff :call Zoom()<CR>

" workaround: sometimes syntax is lost
function! Zoom()
  exec ':ZoomWin'
endfunction
