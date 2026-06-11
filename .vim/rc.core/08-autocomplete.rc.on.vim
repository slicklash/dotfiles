vim9script

g:neosnippet#enable_complete_done = 1

set completeopt=menu,menuone,noselect
set completeitemalign=abbr,kind,menu
set pumheight=12
set autocomplete
set autocompletedelay=80
set autocompletetimeout=250
set complete=F,o,.,w,b,u
set completefunc=NativeComplete

def NativeCompleteFilter(items: list<any>, base: string, default_menu: string): list<any>
  var lbase = tolower(base)
  var result: list<any> = []
  var seen: dict<number> = {}

  for item in items
    var entry: dict<any> = type(item) == v:t_string ? {'word': item} : copy(item)

    var word: string = get(entry, 'word', '')
    if empty(word)
      continue
    endif

    if !empty(lbase) && stridx(tolower(word), lbase) != 0
      continue
    endif

    if empty(get(entry, 'menu', ''))
      entry.menu = default_menu
    endif
    entry.dup = 1

    var key = word .. "\n" .. get(entry, 'menu', '')
    if has_key(seen, key)
      continue
    endif
    seen[key] = 1
    add(result, entry)
  endfor

  return result
enddef

def GetNativePathMatch(input: string): string
  var parts = split(input)
  var token = empty(parts) ? '' : parts[-1]
  if token =~# '[*?[]'
    return ''
  endif
  if stridx(token, '/') >= 0
    return token
  endif
  return ''
enddef

def GetNativePathStart(input: string): number
  var path = GetNativePathMatch(input)
  return empty(path) ? -1 : len(input) - len(path)
enddef

def GetNativePathCandidates(input: string): list<any>
  var path = GetNativePathMatch(input)
  if empty(path)
    return []
  endif

  var slash = strridx(path, '/')
  var raw_dir = slash >= 0 ? strpart(path, 0, slash + 1) : ''
  var raw_tail = strpart(path, len(raw_dir))
  if empty(raw_tail)
    return []
  endif
  var hidden = strpart(raw_tail, 0, 1) ==# '.'

  var resolved_dir: string
  if strpart(raw_dir, 0, 2) ==# '~/'
    resolved_dir = expand(raw_dir)
  elseif strpart(raw_dir, 0, 1) ==# '/'
    resolved_dir = raw_dir
  else
    var base_dir = expand('%:p:h')
    if empty(base_dir)
      base_dir = getcwd()
    endif
    resolved_dir = simplify(fnamemodify(base_dir .. '/' .. raw_dir, ':p'))
  endif

  if !isdirectory(resolved_dir)
    return []
  endif

  var entries: list<any> = []
  for item in sort(glob(resolved_dir .. '/' .. raw_tail .. '*', 0, 1))
    var name = fnamemodify(item, ':t')
    if empty(name) || (!hidden && strpart(name, 0, 1) ==# '.')
      continue
    endif
    add(entries, {
          \ 'word': raw_dir .. name .. (isdirectory(item) ? '/' : ''),
          \ 'menu': '[path]',
          \ })
  endfor

  return entries
enddef

def GetNativeSnippetCandidates(base: string): list<any>
  if !exists('*neosnippet#helpers#get_completion_snippets')
    return []
  endif
  neosnippet#init#check()
  return NativeCompleteFilter(neosnippet#helpers#get_completion_snippets(), base, '[snip]')
enddef

def GetNativeSyntaxCandidates(base: string): list<any>
  if !exists('*necosyntax#gather_candidates')
    return []
  endif
  return NativeCompleteFilter(necosyntax#gather_candidates(), base, '[syn]')
enddef

def GetNativeTmuxCandidates(base: string): list<any>
  if empty($TMUX)
    return []
  endif
  try
    return NativeCompleteFilter(tmuxcomplete#complete(0, base), base, '[tmux]')
  catch
    return []
  endtry
enddef

def GetNativeVimCandidates(input: string, base: string): list<any>
  if &filetype !=# 'vim' || !exists('*necovim#gather_candidates')
    return []
  endif
  return NativeCompleteFilter(necovim#gather_candidates(input, base), base, '[vim]')
enddef

def g:NativeComplete(findstart: number, base: string): any
  var input = getline('.')[ : col('.') - 2]
  var path_start = GetNativePathStart(input)

  if findstart
    var starts: list<number> = []

    if input =~# '\k$'
      add(starts, match(input, '\k*$'))
    endif

    if path_start >= 0
      add(starts, path_start)
    endif

    if &filetype ==# 'vim' && exists('*necovim#get_complete_position')
      var vim_start = necovim#get_complete_position(input)
      if vim_start >= 0
        add(starts, vim_start)
      endif
    endif

    filter(starts, (_, v) => v >= 0)
    return empty(starts) ? -3 : min(starts)
  endif

  var candidates: list<any> = []
  var base_len = strlen(base)

  if path_start >= 0
    extend(candidates, GetNativePathCandidates(input))
  endif

  if base_len >= 1
    extend(candidates, GetNativeSnippetCandidates(base))
  endif

  if base_len >= 2
    extend(candidates, GetNativeSyntaxCandidates(base))
    extend(candidates, GetNativeTmuxCandidates(base))
  endif

  if &filetype ==# 'vim' && base_len >= 1
    extend(candidates, GetNativeVimCandidates(input, base))
  endif

  return {'words': candidates, 'refresh': 'always'}
enddef

def TabComplete(): string
  var line = getline('.')[ : col('.') - 2]

  if exists('*neosnippet#expandable_or_jumpable')
    neosnippet#init#check()
    var trigger = neosnippet#helpers#get_cursor_snippet(neosnippet#helpers#get_snippets('i'), neosnippet#util#get_cur_text())
    if !empty(trigger)
      return neosnippet#expand(trigger)
    endif
    if neosnippet#expandable_or_jumpable()
      return neosnippet#mappings#expand_or_jump_impl()
    endif
  endif

  if pumvisible()
    return "\<C-n>"
  endif

  if match(line, '\k$') >= 0
    return "\<C-x>\<C-u>"
  endif

  return "\<Tab>"
enddef

def Setup()
  inoremap <silent><expr> <CR> pumvisible() && complete_info(['selected']).selected != -1 ? "\<C-y>" : "\<CR>"
  inoremap <silent><expr> <TAB> <SID>TabComplete()
  inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
enddef

autocmd User InitPost ++once Setup()
