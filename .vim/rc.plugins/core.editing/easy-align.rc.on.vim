vim9script

const LONG = {left_margin: 'l', right_margin: 'r', stick_to_left: 's', delimiter_align: 'da', align: 'a'}

def ParseOptions(s: string): dict<any>
  var opts = {}
  if s =~ '^{'
    for [k, v] in items(eval(s))
      opts[get(LONG, k, k)] = v
    endfor
    return opts
  endif
  var rest = s
  while rest != ''
    const m = matchlist(rest, '^\(da\|[lrsa]\)\(\d\+\|[lrc]\+\)\s*\(.*\)$')
    if empty(m)
      throw $'EasyAlign: invalid option: {rest}'
    endif
    opts[m[1]] = m[2] =~ '^\d' ? str2nr(m[2]) : m[2]
    rest = m[3]
  endwhile
  return opts
enddef

def PadToWidth(s: string, w: number, mode: string): string
  const gap = w - strdisplaywidth(s)
  if gap <= 0
    return s
  elseif mode == 'r'
    return repeat(' ', gap) .. s
  elseif mode == 'c'
    return repeat(' ', gap / 2) .. s .. repeat(' ', gap - gap / 2)
  endif
  return s .. repeat(' ', gap)
enddef

def SplitAtDelimiters(body: string, matches: list<dict<any>>, nth: string): list<list<string>>
  const n = len(matches)
  const k = nth == '' ? 1 : nth == '-' ? -1 : str2nr(nth)
  const idx = k < 0 ? n + k : k - 1
  const picked = nth =~ '^\*' ? range(n) : idx >= 0 && idx < n ? [idx] : []

  var fields = []
  var delims = []
  var start = 0
  for i in picked
    const m = matches[i]
    fields->add(trim(strpart(body, start, m.byteidx - start)))
    delims->add(trim(m.text) ?? ' ')
    start = m.byteidx + len(m.text)
  endfor
  fields->add(trim(strpart(body, start)))
  return [fields, delims]
enddef

def AlignLines(first: number, last: number, bang: bool, nth: string, pattern: string, opts: dict<any>)
  const o = extendnew({l: 1, r: 1, s: 0, da: 'r'}, opts)
  const modes = get(o, 'a', nth == '**' ? (bang ? 'rl' : 'lr') : (bang ? 'r' : 'l'))
  const lm = type(o.l) == v:t_string ? o.l : repeat(' ', o.l)
  const rm = type(o.r) == v:t_string ? o.r : repeat(' ', o.r)

  const lines = getline(first, last)
  const bodies = mapnew(lines, (_, line) => trim(line, " \t", 1))
  var found: list<list<dict<any>>> = mapnew(lines, (_, _) => [])
  for m in matchstrlist(bodies, pattern)
    if m.text == ''
      throw 'EasyAlign: pattern matches an empty string'
    endif
    found[m.idx]->add(m)
  endfor

  var rows = []
  for [i, body] in items(bodies)
    const [fields, delims] = SplitAtDelimiters(body, found[i], nth)
    if !empty(delims)
      fields[0] = strpart(lines[i], 0, len(lines[i]) - len(body)) .. fields[0]
      rows->add({lnum: first + i, fields: fields, delims: delims})
    endif
  endfor

  const ColumnWidths = (key: string): list<number> => range(max(mapnew(rows, (_, row) => len(row[key]))))
    ->mapnew((col, _) => max(mapnew(rows, (_, row) => strdisplaywidth(get(row[key], col, '')))))
  const fw = ColumnWidths('fields')
  const dw = ColumnWidths('delims')

  for row in rows
    var out = ''
    for [k, f] in items(row.fields)
      const mode = modes[k % len(modes)]
      if k == len(row.delims)
        out ..= PadToWidth(f, fw[k], mode)
        break
      endif
      const d = PadToWidth(row.delims[k], dw[k], o.da)
      if o.s && mode == 'l'
        out ..= f .. d .. repeat(' ', fw[k] - strdisplaywidth(f)) .. rm
      else
        out ..= PadToWidth(f, fw[k], mode) .. (k == 0 && fw[0] == 0 ? '' : lm) .. d .. rm
      endif
    endfor
    setline(row.lnum, trim(out, " \t", 2))
  endfor
enddef

def EasyAlignCommand(first: number, last: number, bang: bool, args: string)
  try
    const m = matchlist(args, '^\s*\(\*\*\|\*\|-\=\d\+\|-\)\=\s*/\(\%([^/\\]\|\\.\)*\)/\s*\(.*\)$')
    if empty(m) || m[2] == ''
      throw 'EasyAlign: usage: [N-th] /REGEXP/ [OPTIONS]'
    endif
    AlignLines(first, last, bang, m[1], m[2], ParseOptions(m[3]))
  catch /^EasyAlign:\|^Vim\%((\a\+)\)\=:E/
    echohl ErrorMsg | echomsg v:exception | echohl None
  endtry
enddef

command! -bang -range -nargs=+ EasyAlign EasyAlignCommand(<line1>, <line2>, '<bang>' == '!', <q-args>)
