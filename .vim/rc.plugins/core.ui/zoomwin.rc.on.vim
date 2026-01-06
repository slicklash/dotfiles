call dein#add('dr-chip-vim-scripts/ZoomWin', { 'rev': '38b0a76d9ccb67fd4d09807207838c8e8d9663a1' })

function! s:setup() abort
  nnoremap ff <cmd>call Zoom()<CR>
endfunction

autocmd User InitPost ++once call s:setup()

" workaround: sometimes syntax is lost
function! Zoom()
  ZoomWin
endfunction
