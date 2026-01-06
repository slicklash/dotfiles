function! ProfileStart(...) abort
  let l:file = a:0 ? a:1 : expand('~/.vim/profile.log')

  if exists('g:profiling')
    echohl WarningMsg | echom 'Profiling already active' | echohl None
    return
  endif

  let g:profiling = 1
  execute 'profile start' fnameescape(l:file)
  profile func *
  profile file *

  echo 'Profiling started → ' . l:file
endfunction

function! ProfileStop() abort
  if !exists('g:profiling')
    echohl WarningMsg | echom 'Profiling not active' | echohl None
    return
  endif

  profile pause
  unlet g:profiling

  echo 'Profiling stopped'
endfunction

function! Preserve(command) abort
  let l:view   = winsaveview()
  let l:search = @/
  let l:regs   = {}

  " Save named registers
  for l:r in split('abcdefghijklmnopqrstuvwxyz0123456789"', '\zs')
    let l:regs[l:r] = getreg(l:r)
  endfor

  try
    execute 'keepjumps keepmarks silent! ' . a:command
  finally
    call winrestview(l:view)
    let @/ = l:search
    for l:r in keys(l:regs)
      call setreg(l:r, l:regs[l:r])
    endfor
  endtry
endfunction

function! FindNearestFile(filename) abort
  let buf_filename = fnameescape(fnamemodify(bufname('%'), ':p'))
  let relative_path = findfile(a:filename, buf_filename . ';')
  return !empty(relative_path) ? fnamemodify(relative_path, ':p') : ''
endfunction

function! s:is_ignore_special_windows(winnr) abort
  return index(['unite', 'defx', 'denite'], getbufvar(winbufnr(a:winnr), '&filetype')) != -1
endfunction

function! s:find_preview(winnrs) abort
  for n in a:winnrs
    if getbufvar(winbufnr(n), 'preview') == 1
      return n
    endif
  endfor
  return -1
endfunction

function! OpenPath(cmd, path) abort
  let cmd = a:cmd
  let wincmd = ''
  let winnrs = range(1, tabpagewinnr(tabpagenr(), '$'))
  let winnrs = filter(winnrs, '!s:is_ignore_special_windows(v:val)')
  if cmd ==# 'psplit'
    let winnr = s:find_preview(winnrs)
    echo winnr
    execute 'wincmd h'
    if winnr == -1
      execute printf('noswapfile vsplit %s', a:path)
    else
      execute printf('%swincmd w', winnr)
      execute printf('noswapfile edit %s', a:path)
    endif
    let b:preview = 1
    execute 'wincmd l'
    return
  else
    if len(winnrs) > 0
      if cmd =~# 'split'
        let wincmd = 'wincmd h'
      else
        let [_, winnr] = choosewin#start(winnrs, { 'auto_choose': 1, 'hook_enable': 0 })
        let wincmd = printf('%swincmd w', winnr)
      endif
    endif
  endif
  if !empty(wincmd)
    execute wincmd
  endif
  execute printf('noswapfile %s %s', cmd, a:path)
endfunction

function! SyntaxItem()
  echo synIDattr(synID(line('.'),col('.'),1),'name')
endfunction

function! s:matchstrpos_all(str, regex) abort
  let [result, m] = [[], ['', 0, 0]]
  while m[1] != -1
    let m = matchstrpos(a:str, a:regex, m[2])
    if m[1] != -1
      call add(result, m)
    endif
  endwhile
  return result
endfunction

function! EchoHi(msg, ...) abort
  let hi = get(a:, 1, 'String')
  execute 'echohl ' . hi
  echo a:msg
  echohl None
endfunction

function! OpenUrl(url) abort
  execute 'silent !firefox "' . a:url . '" > /dev/null 2>&1 &'
  redraw!
endfunction

function! LookupKeyword() abort
  let url = get(b:, 'keyword_lookup_url')
  if empty(url)
    call EchoHi('b:keyword_lookup_url is not defined', 'ErrorMsg')
    return
  endif
  call OpenUrl(printf(url, expand('<cword>')))
endfunction

function! ExpandSnippet(file, snip, params) abort
  let file = $HOME . '/.vim/snippets/' . a:file

  if !filereadable(file)
    echoerr file . ' not found'
    return v:none
  endif

  let lines = readfile(file)
  let snip = []
  let collect = v:false

  for line in lines

    if line =~ 'snippet ' . a:snip . '$'
      let collect = v:true
      continue
    elseif collect && line =~ 'snippet'
      break
    endif

    if collect
      if line =~ '\v^(abbr|options)' | continue | endif
      let line = strpart(line, 2)
      let snip = add(snip, line)
    endif

  endfor

  if !len(snip)
    echoerr 'Snippet "' . a:snip . '" not found'
    return v:none
  endif

  let snip = join(snip, "\n")

  let pp = insert(a:params, '')
  let i = 0

  while i < len(pp)
    let snip = substitute(snip, '\v(\$\{'.i.'(:\h+)?\}|\$'.i.')', pp[i], 'g')
    let i += 1
  endwhile

  let missing = matchstr(snip, '\v\$\{\d(:\h+)?\}')
  if missing != ''
    echoerr 'Missing required parameter: ' . missing
    return v:none
  endif

  return split(snip, '\n')
endfunction

function! Turbo() abort
  if get(b:, 'turbo', 0)
    return
  endif
  " Syntax performance
  if exists('&synmaxcol')
    setlocal synmaxcol=120
  endif

  " Deoplete
  if exists('*deoplete#disable')
    call deoplete#disable()
  endif

  " Whitespace highlighting (command)
  if exists(':DisableWhitespace')
    silent! DisableWhitespace
  endif

  " LanguageClient
  if exists(':LanguageClientStop')
    silent! LanguageClientStop
  endif

  " ALE
  if exists(':ALEDisableBuffer')
    silent! ALEDisableBuffer
  endif

  " MatchParen
  if exists(':NoMatchParen')
    silent! NoMatchParen
  elseif exists('g:loaded_matchparen')
    let b:matchparen_enabled = 0
    silent! NoMatchParen
  endif

  let b:turbo = 1
endfunction

function! Eslint() abort
  setlocal makeprg=npx\ eslint\ -f\ unix\ src
  make
  copen
endfunction

function! DeleteFile() abort
  let curline = getline('.')
  let choice = confirm('delete ' . curline . '?', "&Yes\n&No\n&Cancel")
  if choice != 1
    return
  endif
  call delete(curline)
  normal dd
endfunction

function! DeleteFiles() abort range
  let start = line("'<")
  let end = line("'>")
  let lines = getbufline(bufnr('%'), start, end)
  let choice = confirm('delete ' . len(lines) . ' files?', "&Yes\n&No\n&Cancel")
  if choice != 1
    return
  endif
  for fl in lines
    call delete(fl)
  endfor
  normal gvd
endfunction

function! SortImports() abort
  let line = getline('.')
  if line !~# 'import '
    echoerr 'no imports found'
    return
  endif
  let line = 'import ' . join(sort(map(split(substitute(line, 'import ', '', ''), ','), {k, v -> trim(v)})), ', ')
  call setline('.', line)
endfunction

function! s:bufnumbers() abort
  let [i, last] = [1, line('$')]
  let result = []
  while i <= last
    let [line, i] = [getline(i), i + 1]
    let p = stridx(line, '#')
    if p != -1
      let line = strpart(line, 0, p)
    endif
    let line = trim(line)
    if match(line,'^\v-?\d+(\.\d+)?$') == 0
      call add(result, str2float(line))
    endif
  endwhile
  return result
endfunction

function! s:apply(fn, ...) abort
  let xs = s:bufnumbers()
  let initial = get(a:000, 0, v:false) ? xs[0] : 0
  return reduce(xs, a:fn, initial)
endfunction

function! Sum() abort
  call EchoHi(s:apply({ acc, x -> acc + x }), 'DiffAdd')
endfunction

function! Avg() abort
  let xs = s:bufnumbers()
  call EchoHi(reduce(xs, { acc, x -> acc + x }) / len(xs), 'DiffAdd')
endfunction

function! Min(...) abort
  let n = get(a:000, 0, 1)
  call EchoHi(sort(s:bufnumbers(), 'f')[0:n-1], 'DiffAdd')
endfunction

function! Max(...) abort
  let n = get(a:000, 0, 1)
  call EchoHi(reverse(sort(s:bufnumbers(), 'f'))[0:n-1], 'DiffAdd')
endfunction

