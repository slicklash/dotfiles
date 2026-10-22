vim9script

const tag_name = '<\zs/\?\%([[:alpha:]_:]\|[^\x00-\x7F]\)\%([-._:[:alnum:]]\|[^\x00-\x7F]\)*'
const skip_syn = 'String\|Comment'

def Clear()
  if exists('w:matchtag_id')
    silent! matchdelete(w:matchtag_id)
    unlet w:matchtag_id
  endif
enddef

def CursorTag(): list<any>
  var c = col('.')
  var line = getline('.')
  var [m, s, _] = matchstrpos(line, '\(<[^<>]*\%' .. c .. 'c.\{-}>\)\|\(\%' .. c .. 'c<.\{-}>\)')
  if m =~ '/>$'
    return ['', 0]
  elseif empty(m)
    [m, s, _] = matchstrpos(line, '\(<[^<>]*\%' .. c .. 'c.\{-}$\)\|\(\%' .. c .. 'c<.\{-}$\)')
    if empty(m)
      return ['', 0]
    endif
  endif
  return [matchstr(m, tag_name), s + 1]
enddef

def Highlight()
  Clear()
  if pumvisible()
    return
  endif

  var [name, tag_col] = CursorTag()
  if empty(name)
    return
  endif

  var forwards = name[0] !=# '/'
  var bare = forwards ? name : name[1 :]
  var starttag = '\V<' .. bare .. '\%(\_s\%(\.\{-}\|\_.\{-}\%<' .. line('.') .. 'l\)/\@<!\)\?>'
  var endtag = '\V</' .. bare .. '\_s\*' .. (forwards ? '' : '\zs') .. '>'

  var Skip: any = () => synIDattr(synID(line('.'), col('.'), 0), 'name') =~? skip_syn
  if Skip()
    Skip = ''
  endif

  var [lnum, col] = searchpairpos(starttag, '', endtag, forwards ? 'nW' : 'nWb', Skip,
        \ forwards ? line('w$') : line('w0'), 300)
  if lnum == 0
    return
  endif

  w:matchtag_id = matchaddpos('MatchParen', [
        \ [line('.'), tag_col + 1, strlen(name)],
        \ [lnum, col + 1, strlen(bare) + (forwards ? 1 : 0)],
        \ ])
enddef

def Setup()
  augroup matchtag_buf
    autocmd! * <buffer>
    autocmd CursorMoved,CursorMovedI,WinEnter <buffer> Highlight()
    autocmd BufLeave,WinLeave <buffer> Clear()
  augroup END
enddef

augroup matchtag
  autocmd!
  autocmd FileType html,xml,xsd,jsx,javascript.jsx,typescript.tsx Setup()
augroup END
