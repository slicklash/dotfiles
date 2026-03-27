let g:neosnippet#enable_complete_done = 1

set completeopt=menu,menuone,noselect
set completeitemalign=abbr,kind,menu
set pumheight=12
set autocomplete
set autocompletedelay=80
set autocompletetimeout=250
set complete=F,o,.,w,b,u
set completefunc=NativeComplete

function! s:native_complete_filter(items, base, default_menu) abort
  let l:base = tolower(a:base)
  let l:result = []
  let l:seen = {}

  for l:item in a:items
    if type(l:item) ==# v:t_string
      let l:item = {'word': l:item}
    else
      let l:item = copy(l:item)
    endif

    let l:word = get(l:item, 'word', '')
    if empty(l:word)
      continue
    endif

    if !empty(l:base) && stridx(tolower(l:word), l:base) != 0
      continue
    endif

    if empty(get(l:item, 'menu', ''))
      let l:item.menu = a:default_menu
    endif
    let l:item.dup = 1

    let l:key = l:word . "\n" . get(l:item, 'menu', '')
    if has_key(l:seen, l:key)
      continue
    endif
    let l:seen[l:key] = 1
    call add(l:result, l:item)
  endfor

  return l:result
endfunction

function! s:native_path_match(input) abort
  let l:parts = split(a:input)
  let l:token = empty(l:parts) ? '' : l:parts[-1]
  if stridx(l:token, '/') >= 0
    return l:token
  endif
  return ''
endfunction

function! s:native_path_start(input) abort
  let l:path = s:native_path_match(a:input)
  return empty(l:path) ? -1 : len(a:input) - len(l:path)
endfunction

function! s:native_path_candidates(input) abort
  let l:path = s:native_path_match(a:input)
  if empty(l:path)
    return []
  endif

  let l:slash = strridx(l:path, '/')
  let l:raw_dir = l:slash >= 0 ? strpart(l:path, 0, l:slash + 1) : ''
  let l:raw_tail = strpart(l:path, len(l:raw_dir))
  let l:hidden = strpart(l:raw_tail, 0, 1) ==# '.'

  if strpart(l:raw_dir, 0, 2) ==# '~/'
    let l:resolved_dir = expand(l:raw_dir)
  elseif strpart(l:raw_dir, 0, 1) ==# '/'
    let l:resolved_dir = l:raw_dir
  else
    let l:base_dir = expand('%:p:h')
    if empty(l:base_dir)
      let l:base_dir = getcwd()
    endif
    let l:resolved_dir = simplify(fnamemodify(l:base_dir . '/' . l:raw_dir, ':p'))
  endif

  if !isdirectory(l:resolved_dir)
    return []
  endif

  let l:entries = []
  for l:item in sort(glob(l:resolved_dir . '/' . l:raw_tail . '*', 0, 1))
    let l:name = fnamemodify(l:item, ':t')
    if empty(l:name) || (!l:hidden && strpart(l:name, 0, 1) ==# '.')
      continue
    endif
    call add(l:entries, {
          \ 'word': l:raw_dir . l:name . (isdirectory(l:item) ? '/' : ''),
          \ 'menu': '[path]',
          \ })
  endfor

  return l:entries
endfunction

function! s:native_snippet_candidates(base) abort
  if !exists('*neosnippet#helpers#get_completion_snippets')
    return []
  endif
  call neosnippet#init#check()
  return s:native_complete_filter(neosnippet#helpers#get_completion_snippets(), a:base, '[snip]')
endfunction

function! s:native_syntax_candidates(base) abort
  if !exists('*necosyntax#gather_candidates')
    return []
  endif
  return s:native_complete_filter(necosyntax#gather_candidates(), a:base, '[syn]')
endfunction

function! s:native_tmux_candidates(base) abort
  if empty($TMUX)
    return []
  endif
  try
    return s:native_complete_filter(tmuxcomplete#complete(0, a:base), a:base, '[tmux]')
  catch
    return []
  endtry
endfunction

function! s:native_vim_candidates(input, base) abort
  if &filetype !=# 'vim' || !exists('*necovim#gather_candidates')
    return []
  endif
  return s:native_complete_filter(necovim#gather_candidates(a:input, a:base), a:base, '[vim]')
endfunction

function! NativeComplete(findstart, base) abort
  let l:input = getline('.')[: col('.') - 2]

  if a:findstart
    let l:starts = [match(l:input, '\k*$')]

    let l:path_start = s:native_path_start(l:input)
    if l:path_start >= 0
      call add(l:starts, l:path_start)
    endif

    if &filetype ==# 'vim' && exists('*necovim#get_complete_position')
      let l:vim_start = necovim#get_complete_position(l:input)
      if l:vim_start >= 0
        call add(l:starts, l:vim_start)
      endif
    endif

    return min(filter(l:starts, 'v:val >= 0'))
  endif

  let l:candidates = []

  if s:native_path_start(l:input) >= 0
    call extend(l:candidates, s:native_path_candidates(l:input))
  endif

  if strlen(a:base) >= 1
    call extend(l:candidates, s:native_snippet_candidates(a:base))
  endif

  if strlen(a:base) >= 2
    call extend(l:candidates, s:native_syntax_candidates(a:base))
    call extend(l:candidates, s:native_tmux_candidates(a:base))
  endif

  if &filetype ==# 'vim'
    call extend(l:candidates, s:native_vim_candidates(l:input, a:base))
  endif

  return {'words': l:candidates, 'refresh': 'always'}
endfunction

function! s:tab_complete() abort
  let l:line = getline('.')[: col('.') - 2]

  if exists('*neosnippet#expandable_or_jumpable')
    call neosnippet#init#check()
    let l:trigger = neosnippet#helpers#get_cursor_snippet(neosnippet#helpers#get_snippets('i'), neosnippet#util#get_cur_text())
    if !empty(l:trigger)
      return neosnippet#expand(l:trigger)
    endif
    if neosnippet#expandable_or_jumpable()
      return neosnippet#mappings#expand_or_jump_impl()
    endif
  endif

  if pumvisible()
    return "\<C-n>"
  endif

  if match(l:line, '\k$') >= 0
    return "\<C-x>\<C-u>"
  endif

  return "\<Tab>"
endfunction

function! s:setup() abort
  inoremap <silent><expr> <CR> pumvisible() && complete_info(['selected']).selected != -1 ? "\<C-y>" : "\<CR>"
  inoremap <silent><expr> <TAB> <SID>tab_complete()
  inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endfunction

autocmd User InitPost ++once call s:setup()
