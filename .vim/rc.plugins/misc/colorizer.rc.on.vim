vim9script

const prop_id = 7351
const pattern = '#\%(\x\{8}\|\x\{6}\|\x\{3,4}\)\>\|rgba\?(\s*\d\{1,3}[ ,]\+\d\{1,3}[ ,]\+\d\{1,3}[^)]*)'
var defined: dict<string> = {}

def ToRgb(text: string): list<number>
  if text[0] ==# '#'
    var h = text[1 :]
    if strlen(h) <= 4
      return [str2nr(h[0] .. h[0], 16), str2nr(h[1] .. h[1], 16), str2nr(h[2] .. h[2], 16)]
    endif
    return [str2nr(h[0 : 1], 16), str2nr(h[2 : 3], 16), str2nr(h[4 : 5], 16)]
  endif
  var m = matchlist(text, '(\s*\(\d\+\)[ ,]\+\(\d\+\)[ ,]\+\(\d\+\)')
  return [min([str2nr(m[1]), 255]), min([str2nr(m[2]), 255]), min([str2nr(m[3]), 255])]
enddef

def Xterm(rgb: list<number>): number
  var [r, g, b] = mapnew(rgb, (_, v) => v < 48 ? 0 : v < 115 ? 1 : (v - 35) / 40)
  return 16 + 36 * r + 6 * g + b
enddef

def PropType(rgb: list<number>): string
  var hex = printf('%02x%02x%02x', rgb[0], rgb[1], rgb[2])
  var name = 'Colorizer_' .. hex
  if !has_key(defined, name)
    var light = 0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2] > 150
    defined[name] = printf('hi %s guibg=#%s guifg=%s ctermbg=%d ctermfg=%d',
          \ name, hex, light ? '#000000' : '#ffffff', Xterm(rgb), light ? 16 : 231)
    execute defined[name]
    prop_type_add(name, {highlight: name})
  endif
  return name
enddef

def Refresh()
  var top = line('w0')
  var bot = line('w$')
  prop_remove({id: prop_id, all: true}, top, bot)
  for lnum in range(top, bot)
    var line = getline(lnum)
    var [m, s, e] = matchstrpos(line, pattern)
    while s >= 0
      prop_add(lnum, s + 1, {length: e - s, type: PropType(ToRgb(m)), id: prop_id})
      [m, s, e] = matchstrpos(line, pattern, e)
    endwhile
  endfor
enddef

def Setup()
  augroup colorizer_buf
    autocmd! * <buffer>
    autocmd BufWinEnter,TextChanged,TextChangedI,WinScrolled <buffer> Refresh()
  augroup END
  Refresh()
enddef

command ColorHighlight Setup()

augroup colorizer
  autocmd!
  autocmd FileType css,scss,html,javascript.jsx,typescript.tsx Setup()
  autocmd ColorScheme * mapnew(defined, (_, cmd) => execute(cmd))
augroup END
