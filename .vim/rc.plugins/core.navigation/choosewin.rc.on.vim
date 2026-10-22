vim9script

const labels = 'ABCDEFGHIJKLMNOPQRTUVWXYZ'

def g:ChooseWin(winnrs: list<number> = [], auto_choose = false): number
  var wins = empty(winnrs) ? range(1, winnr('$')) : winnrs[: len(labels) - 1]
  if empty(wins) || (auto_choose && len(wins) == 1)
    return empty(wins) ? 0 : wins[0]
  endif

  hi default ChooseWinLabel ctermfg=255 ctermbg=238 cterm=bold guifg=#eeeeee guibg=#444444 gui=bold
  hi default ChooseWinLabelCurrent ctermfg=232 ctermbg=255 cterm=bold guifg=#080808 guibg=#eeeeee gui=bold

  var label2win: dict<number> = {}
  var popups: list<number> = []
  for i in range(len(wins))
    var nr = wins[i]
    var [row, col] = win_screenpos(nr)
    label2win[labels[i]] = nr
    add(popups, popup_create(labels[i], {
          \ line: row + winheight(nr) / 2 - 1,
          \ col: col + winwidth(nr) / 2 - 3,
          \ padding: [1, 3, 1, 3],
          \ highlight: nr == winnr() ? 'ChooseWinLabelCurrent' : 'ChooseWinLabel',
          \ zindex: 300,
          \ }))
  endfor
  redraw

  var key = getcharstr()
  for id in popups
    popup_close(id)
  endfor
  return get(label2win, toupper(key), 0)
enddef

def Jump()
  var nr = g:ChooseWin()
  if nr > 0
    execute $':{nr}wincmd w'
  endif
enddef

nnoremap - <ScriptCmd>Jump()<CR>
