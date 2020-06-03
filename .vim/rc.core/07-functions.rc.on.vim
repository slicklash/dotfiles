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
  let l:last_view = winsaveview()
  let l:last_search = getreg('/')
  execute 'keepjumps ' . a:command
  call winrestview(l:last_view)
  call setreg('/', l:last_search)
endfunction

let g:show_syntax_item_in_statusline = 0

function! SyntaxItem()
  " if g:show_syntax_item_in_statusline == 1
  return synIDattr(synID(line('.'),col('.'),1),'name') . ' |'
  " endif
  " return ''
endfunction

function! ToggleSyntaxItem()
  if g:show_syntax_item_in_statusline == 0
    let g:show_syntax_item_in_statusline=1
  else
    let g:show_syntax_item_in_statusline=0
  endif
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
  let l:hi = get(a:, 1, 'String')
  if l:hi ==? 'ErrorMsg'
    echohl ErrorMsg
  else
    echohl String
  endif
  echo a:msg
  echohl None
endfunction

function! OpenUrl(url) abort
  execute 'silent !chromium-browser "' . a:url . '" > /dev/null 2>&1 &'
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
  let l:url = get(b:, 'keyword_lookup_url')
  if empty(l:url)
    call EchoHi('b:keyword_lookup_url is not defined', 'ErrorMsg')
    return
  endif
  call OpenUrl(printf(l:url, expand('<cword>')))
endfunction

function! _get(url, ...)
  let l:headers = a:0 > 0 ? { 'Authorization': 'Basic ' . webapi#base64#b64encode(a:1 . ':' . a:2) } : {}
  redraw | echon 'GET' . a:url . '...'
  return webapi#http#get(a:url, '', l:headers)
endfunction

function! _show(obj, ft)
  top new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowarn
  if a:ft == 'http/json'
    if len(a:obj.status) && a:obj.status[0] == '2' && len(a:obj.content)
      call setline(1, a:obj.content)
    else
      call setline(1, string(a:obj))
      silent %s/\v'([^']*)'/"\1"/g
    endif
    setlocal ft=json
  else
    call setline(1, string(a:obj))
  endif
  call JsBeautify()
  setlocal nomodifiable
endfunction

function! _search_to_local_list(term)
  let l:temp = expand('%')
  if !filereadable(l:temp)
    let l:temp = tempname()
    exec 'w ' . l:temp
  endif
  let l:search = 'lvimgrep ' . a:term . ' ' . l:temp
  exec l:search
  exec 'lopen'
endfunction

function! ExpandSnippet(file, snip, params) abort
  let l:file = $HOME . '/.vim/snippets/' . a:file

  if !filereadable(l:file)
    echoerr l:file . ' not found'
    return v:none
  endif

  let l:lines = readfile(l:file)
  let l:snip = []
  let l:collect = v:false

  for line in l:lines

    if line =~ 'snippet ' . a:snip . '$'
      let l:collect = v:true
      continue
    elseif l:collect && line =~ 'snippet'
      break
    endif

    if l:collect
      if line =~ '\v^(abbr|options)' | continue | endif
      let line = strpart(line, 2)
      let l:snip = add(l:snip, line)
    endif

  endfor

  if !len(l:snip)
    echoerr 'Snippet "' . a:snip . '" not found'
    return v:none
  endif

  let l:snip = join(l:snip, "\n")

  let l:pp = insert(a:params, '')
  let l:i = 0

  while l:i < len(l:pp)
    let l:snip = substitute(l:snip, '\v(\$\{'.l:i.'(:\h+)?\}|\$'.l:i.')', l:pp[l:i], 'g')
    let l:i += 1
  endwhile

  let l:missing = matchstr(l:snip, '\v\$\{\d(:\h+)?\}')
  if l:missing != ''
    echoerr 'Missing required parameter: ' . l:missing
    return v:none
  endif

  return split(l:snip, '\n')
endfunction

function! WhyBundled() abort
  let i = 1
  let last = line("$")
  let lines = []
  while i < last
    let line = getline(i)
    let isModule = line =~# 'MODULE'
    if isModule || line =~# 'FILE'
      let size = getline(i + (isModule ? 3 : 2))
      let size = substitute(size, '^.* size: \(\d\+\).*$', '\1', '')
      let line = printf('%04d KiB%s', size, substitute(line, 'FILE', 'FILE  ', ''))
      call add(lines, line)
    endif
    let i += 1
  endwhile
  normal ggVGd
  call setbufline(bufnr('%'), 1, lines)
  sort!
endfunction
