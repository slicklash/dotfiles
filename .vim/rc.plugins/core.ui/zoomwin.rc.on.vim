if InitStep() == 0
  call dein#add('dr-chip-vim-scripts/ZoomWin')
  finish
endif

nnoremap ff :call Zoom()<CR>

" workaround: sometimes syntax is lost
function! Zoom()
  exec ':ZoomWin'
endfunction
