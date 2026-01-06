call dein#add('t9md/vim-choosewin', { 'rev': '839da609d9b811370216bdd9d4512ec2d0ac8644' })

function! s:setup() abort
  let g:choosewin_overlay_enable = 1
  let g:choosewin_blink_on_land = 0
  let g:choosewin_statusline_replace = 0
  let g:choosewin_tabline_replace  = 0

  nnoremap - <cmd>ChooseWin<cr>
endfunction

autocmd User InitPost ++once call s:setup()
