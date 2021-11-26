function! ProfileStart()
  :profile start profile.log
  :profile func *
  :profile file *
endfunction

function! ProfileStop()
  :profile pause
  :noautocmd qall!
endfunction

function! Preserve(command)
  let last_view = winsaveview()
  let last_search = getreg('/')
  execute 'keepjumps ' . a:command
  call winrestview(last_view)
  call setreg('/', last_search)
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
  if hi ==? 'ErrorMsg'
    echohl ErrorMsg
  else
    echohl String
  endif
  echo a:msg
  echohl None
endfunction

function! OpenUrl(url) abort
  execute 'silent !firefox "' . a:url . '" > /dev/null 2>&1 &'
  redraw!
endfunction

function! OpenUrlAtCursor()
  let regex = '\(www\.\|https\?:\/\/\)[^ ]\+'
  let urls = s:matchstrpos_all(getline('.'), regex)
  if empty(urls)
    return EchoHi('URL not found', 'ErrorMsg')
  endif
  if len(urls) == 1
    return OpenUrl(urls[0][0])
  endif
  let pos = getcurpos()[2]
  for url_match in urls
    let [url, start, end] = url_match
    if pos >= start && pos <= end
      return OpenUrl(url)
    endif
  endfor
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

function _cmp(a, b)
  if a:a < a:b
    return -1
  elseif a:a == a:b
    return 0
  endif
  return 1
endfunction

function! WhyBundled(...) abort
  let sortByIndex = a:0 > 0 ? a:1 : 0
  echo sortByIndex
  let i = 1
  let last = line("$")
  let items = []
  while i < last
    let line = getline(i)
    let isModule = line =~# 'MODULE'
    if isModule || line =~# 'FILE'
      let size = getline(i + (isModule ? 3 : 2))
      let size = substitute(size, '^.* size: \(\d\+\).*$', '\1', '')
      let name = substitute(line, ' FILE', ' FILE  ', '')
      call add(items, [str2nr(size), name])
    endif
    let i += 1
  endwhile
  let items = sort(items, {a, b -> _cmp(b[sortByIndex], a[sortByIndex])})
  let items = map(items,  {_, val -> printf('%04d KiB%s', val[0], val[1])})
  normal ggVGd
  call setbufline(bufnr('%'), 1, items)
endfunction

function! Turbo() abort
  setlocal synmaxcol=120
  call deoplete#disable()
  DisableWhitespace
  LanguageClientStop
  ALEDisableBuffer
  NoMatchParen
endfunction

function! Eslint() abort
  setlocal makeprg=npx\ eslint\ -f\ unix\ src
  make
  copen
endfunction

function! EslintSled() abort
  setlocal makeprg=npx\ eslint\ -f\ unix\ sled
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

function! s:reduce(list, fn, acc) abort
  let acc = a:acc
  for x in a:list
    let acc = a:fn(acc, x)
  endfor
  return acc
endfunction

function! Hist(...) abort
  let [i, last] = [1, line('$')]
  let [lines, items] = [[], []]
  let hints = [
        \'Failed to get metaSite GrpcStatusError',
        \'SSR failed for instanceId',
        \'method=GET',
        \'method=HEAD' ,
        \]
  let max_len = s:reduce(hints, {acc, x -> max([acc, len(x)])}, 0)
  let counter = {}
  while i < last
    let [line, i] = [getline(i), i + 1]
    let skip = line !~# '2020 @'
    if skip
      continue
    endif
    let line = trim(strcharpart(line, 30))
    if empty(line)
      continue
    endif
    call add(lines, line)
    for key in hints
      let name = key . repeat(' ', max_len - len(key))
      if line =~# key
        let m = matchstrpos(line, 'status=\d\+')
        let name .= m[1] != -1 ? ' ' . m[0] : repeat(' ', 11)
        let m = matchstrpos(line, 'url=/[^/? ]*')
        if m[1] != -1
          let ssr = line =~# 'ssr=true' ? 'ssr=true ' : 'ssr=false'
          let name .= printf(' %s %s', ssr, m[0])
        else
          let name .= repeat(' ', 10)
        endif
        let counter[name] = get(counter, name, 0) + 1
      endif
    endfor
  endwhile
  for key in keys(counter)
    let n = counter[key]
    call add(items, [key, n])
  endfor
  let items = sort(items, {a, b -> _cmp(b[1], a[1])})
  let items = map(items, {_, val -> printf('%4d %s', val[1], trim(val[0]))})
  call add(items, '')
  vnew
  call setbufline(bufnr('%'), 1, extend(items, sort(lines)))
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowarn
endfunction
