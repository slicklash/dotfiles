vim9script

def g:ProfileStart(...rest: list<any>)
  var profile_file = len(rest) > 0 ? rest[0] : expand('~/.vim/profile.log')

  if exists('g:profiling')
    echohl WarningMsg
    echomsg 'Profiling already active'
    echohl None
    return
  endif

  g:profiling = 1
  execute 'profile start' fnameescape(profile_file)
  profile func *
  profile file *

  echo 'Profiling started → ' .. profile_file
enddef

def g:ProfileStop()
  if !exists('g:profiling')
    echohl WarningMsg
    echomsg 'Profiling not active'
    echohl None
    return
  endif

  profile pause
  unlet g:profiling

  echo 'Profiling stopped'
enddef

def g:Preserve(command: string)
  var view = winsaveview()
  var search = @/
  var regs: dict<string> = {}

  # Save named registers
  for r in split('abcdefghijklmnopqrstuvwxyz0123456789"', '\zs')
    regs[r] = getreg(r)
  endfor

  try
    execute 'keepjumps keepmarks silent! ' .. command
  finally
    winrestview(view)
    @/ = search
    for r in keys(regs)
      setreg(r, regs[r])
    endfor
  endtry
enddef

def g:FindNearestFile(filename: string): string
  var buf_filename = fnameescape(fnamemodify(bufname('%'), ':p'))
  var relative_path = findfile(filename, buf_filename .. ';')
  return !empty(relative_path) ? fnamemodify(relative_path, ':p') : ''
enddef

def g:Zoom()
  if get(t:, 'native_zoom_active', 0)
    tabclose
    return
  endif

  if winnr('$') == 1
    return
  endif

  tab split
  t:native_zoom_active = 1
enddef

def IsIgnoreSpecialWindows(nr: number): bool
  return index(['diff', 'qf', 'gitcommit', 'fern', 'help'], getbufvar(winbufnr(nr), '&filetype')) != -1
enddef

def g:OpenPath(cmd: string, path: string)
  var curr_winid = win_getid()
  var winnrs = filter(range(1, tabpagewinnr(tabpagenr(), '$')), (_, v) => !IsIgnoreSpecialWindows(v))
  var wincmd = ''

  if cmd =~# 'split'
    wincmd = 'wincmd h'
  else
    if len(winnrs) > 0
      var chosen = choosewin#start(winnrs, {'auto_choose': 1, 'hook_enable': 0})
      var winnr = chosen[1]
      if winnr > 0
        wincmd = printf(':%dwincmd w', winnr)
      endif
    endif
  endif

  if !empty(wincmd)
    execute wincmd
  endif

  if cmd ==# 'edit_keep'
    execute printf('noswapfile %s %s', 'edit', path)
    win_gotoid(curr_winid)
  else
    execute printf('noswapfile %s %s', cmd, path)
  endif
enddef

def g:SyntaxItem()
  echo synIDattr(synID(line('.'), col('.'), 1), 'name')
enddef

def MatchstrposAll(str: string, regex: string): list<any>
  var result: list<any> = []
  var m = ['', 0, 0]
  while m[1] != -1
    m = matchstrpos(str, regex, m[2])
    if m[1] != -1
      add(result, m)
    endif
  endwhile
  return result
enddef

def g:EchoHi(msg: any, ...rest: list<any>)
  var hi: string = get(rest, 0, 'String')
  execute 'echohl ' .. hi
  echo msg
  echohl None
enddef

def g:LookupKeyword()
  var url: string = get(b:, 'keyword_lookup_url', '')
  if empty(url)
    g:EchoHi('b:keyword_lookup_url is not defined', 'ErrorMsg')
    return
  endif
  dist#vim9#Open(printf(url, expand('<cword>')))
enddef

def g:ExpandSnippet(file: string, snip: string, params: list<any>): list<string>
  var path = $HOME .. '/.vim/snippets/' .. file

  if !filereadable(path)
    echoerr path .. ' not found'
    return []
  endif

  var lines = readfile(path)
  var collected: list<string> = []
  var collect = false

  for line in lines

    if line =~ 'snippet ' .. snip .. '$'
      collect = true
      continue
    elseif collect && line =~ 'snippet'
      break
    endif

    if collect
      if line =~ '\v^(abbr|options)'
        continue
      endif
      add(collected, strpart(line, 2))
    endif

  endfor

  if len(collected) == 0
    echoerr 'Snippet "' .. snip .. '" not found'
    return []
  endif

  var body = join(collected, "\n")

  var pp = insert(copy(params), '')
  var i = 0

  while i < len(pp)
    body = substitute(body, '\v(\$\{' .. i .. '(:\h+)?\}|\$' .. i .. ')', pp[i], 'g')
    i += 1
  endwhile

  var missing = matchstr(body, '\v\$\{\d(:\h+)?\}')
  if missing != ''
    echoerr 'Missing required parameter: ' .. missing
    return []
  endif

  return split(body, '\n')
enddef

def g:Turbo()
  if get(b:, 'turbo', 0)
    return
  endif
  # Syntax performance
  if exists('&synmaxcol')
    setlocal synmaxcol=120
  endif

  # Deoplete
  if exists('*deoplete#disable')
    deoplete#disable()
  endif

  # Whitespace highlighting (command)
  if exists(':DisableWhitespace') > 0
    silent! execute 'DisableWhitespace'
  endif

  # LanguageClient
  if exists(':LanguageClientStop') > 0
    silent! execute 'LanguageClientStop'
  endif

  # ALE
  if exists(':ALEDisableBuffer') > 0
    silent! execute 'ALEDisableBuffer'
  endif

  # MatchParen
  if exists(':NoMatchParen') > 0
    silent! execute 'NoMatchParen'
  elseif exists('g:loaded_matchparen')
    b:matchparen_enabled = 0
    silent! execute 'NoMatchParen'
  endif

  b:turbo = 1
enddef

def g:HardMode()
  nnoremap <buffer> h <nop>
  nnoremap <buffer> j <nop>
  nnoremap <buffer> k <nop>
  nnoremap <buffer> l <nop>
enddef

def g:Eslint()
  setlocal makeprg=npx\ eslint\ -f\ unix\ src
  make
  copen
enddef

def g:DeleteFile()
  var curline = getline('.')
  var choice = confirm('delete ' .. curline .. '?', "&Yes\n&No\n&Cancel")
  if choice != 1
    return
  endif
  delete(curline)
  normal dd
enddef

def g:DeleteFiles()
  var startln = line("'<")
  var endln = line("'>")
  var lines = getbufline(bufnr('%'), startln, endln)
  var choice = confirm('delete ' .. len(lines) .. ' files?', "&Yes\n&No\n&Cancel")
  if choice != 1
    return
  endif
  for fl in lines
    delete(fl)
  endfor
  normal gvd
enddef

def g:SortImports()
  var line = getline('.')
  if line !~# 'import '
    echoerr 'no imports found'
    return
  endif
  line = 'import ' .. join(sort(map(split(substitute(line, 'import ', '', ''), ','), (k, v) => trim(v))), ', ')
  setline('.', line)
enddef

def GetBufferNumbers(): list<float>
  var i = 1
  var last = line('$')
  var result: list<float> = []
  while i <= last
    var line = getline(i)
    i += 1
    var p = stridx(line, '#')
    if p != -1
      line = strpart(line, 0, p)
    endif
    line = trim(line)
    if match(line, '^\v-?\d+(\.\d+)?$') == 0
      add(result, str2float(line))
    endif
  endwhile
  return result
enddef

def Apply(Fn: func, ...rest: list<any>): float
  var xs = GetBufferNumbers()
  var use_first = len(rest) > 0 && rest[0]
  var initial = use_first ? xs[0] : 0.0
  return reduce(xs, Fn, initial)
enddef

def g:Sum()
  g:EchoHi(Apply((acc, x) => acc + x), 'DiffAdd')
enddef

def g:Avg()
  var xs = GetBufferNumbers()
  g:EchoHi(reduce(xs, (acc, x) => acc + x) / len(xs), 'DiffAdd')
enddef

def g:Min(...rest: list<any>)
  var n: number = len(rest) > 0 ? rest[0] : 1
  g:EchoHi(sort(GetBufferNumbers(), 'f')[0 : n - 1], 'DiffAdd')
enddef

def g:Max(...rest: list<any>)
  var n: number = len(rest) > 0 ? rest[0] : 1
  g:EchoHi(reverse(sort(GetBufferNumbers(), 'f'))[0 : n - 1], 'DiffAdd')
enddef

def g:JsBeautify()
  silent %!prettier --parser=babel-ts
  echo ''
enddef

def g:JsonBeautify()
  silent %!prettier --parser=json
  echo ''
enddef

def g:HtmlBeautify()
  silent %!prettier --parser=html
  echo ''
enddef

def g:CssBeautify()
  silent %!prettier --parser=css
  echo ''
enddef

command! JsBeautify call JsBeautify()
command! JsonBeautify call JsonBeautify()
command! HtmlBeautify call HtmlBeautify()
command! CssBeautify call CssBeautify()


command! Tail call g:Tail()

def g:Tail()
  setlocal autoread
  setlocal noswapfile
  setlocal nowrap
  normal! G

  # Start timer to check file even when pane inactive
  if has('timers')
    timer_start(500, (_) => execute('checktime'), {'repeat': -1})
  endif
enddef
