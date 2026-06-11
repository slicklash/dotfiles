vim9script

dein#add('t9md/vim-choosewin', {'rev': '839da609d9b811370216bdd9d4512ec2d0ac8644'})

def Setup()
  g:choosewin_overlay_enable = 1
  g:choosewin_blink_on_land = 0
  g:choosewin_statusline_replace = 0
  g:choosewin_tabline_replace = 0

  nnoremap - <cmd>ChooseWin<cr>
enddef

autocmd User InitPost ++once Setup()
