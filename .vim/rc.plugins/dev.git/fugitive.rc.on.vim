call dein#add('tpope/vim-fugitive', { 'rev': '3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0' })

function! s:setup() abort
  nnoremap <silent> <leader>gg <cmd>Git<cr>
  nnoremap <silent> <leader>gb <cmd>Gblame<cr>
  nnoremap <silent> <leader>gm  <cmd>Gvdiffsplit main<cr>
endfunction

autocmd User InitPost ++once call s:setup()

function! FugitiveOpenFile() abort
  let path = expand('<cfile>')
  if empty(path)
    return
  endif
  let cwd = split(getcwd(), '/')[-1]
  let n = stridx(path, cwd)
  let path = strpart(path, n + len(cwd) + 1)
  wincmd k
  execute printf('noswapfile vsplit %s', path)
endfunction

function! FuView()
  let cwd = split(getcwd(), '/')
  let curline = strpart(getline('.'), 2)
  for i in range(len(cwd) - 1)
    let prefix = join(slice(cwd, i), '/')
    if stridx(curline, prefix) == 0
      break
    endif
  endfor
  let path = '/' . join(slice(cwd, 0, i), '/') . '/' . curline
  echo path
  execute 'silent !xdg-open ' . path . '> /dev/null 2>&1 &'
  redraw!
endfunction

autocmd User FugitiveIndex nnoremap <buffer> E <cmd>call FuView()<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete

function! s:FugitiveNormalizePath(path) abort
  let l:path = a:path
  if l:path =~# ' -> '
    let l:path = substitute(l:path, '^.* -> ', '', '')
  endif
  return l:path
endfunction

function! s:FugitiveExtractPath(line) abort
  let l:m = matchlist(a:line, '^\s*[MADRCU?!T]\+\s\+\(.*\)$')
  if empty(l:m)
    return ''
  endif
  return s:FugitiveNormalizePath(l:m[1])
endfunction

function! s:ParentDirs(path) abort
  let l:parts = split(a:path, '/')
  if len(l:parts) <= 1
    return []
  endif
  return l:parts[:-2]
endfunction

function! s:ParentKey(path, depth) abort
  let l:dirs = s:ParentDirs(a:path)
  if empty(l:dirs)
    return ''
  endif
  let l:end = min([len(l:dirs), a:depth]) - 1
  return join(l:dirs[:l:end], '/')
endfunction

function! s:FamilyRoot(path) abort
  let l:dirs = s:ParentDirs(a:path)
  if empty(l:dirs)
    return ''
  endif
  if len(l:dirs) == 1
    return l:dirs[0]
  endif
  return join(l:dirs[:1], '/')
endfunction

function! s:ChooseDepthByFamily(paths) abort
  " Returns dict: family_root -> chosen depth (2 or 3)
  let l:families = {}

  for l:path in a:paths
    let l:family = s:FamilyRoot(l:path)
    if !has_key(l:families, l:family)
      let l:families[l:family] = []
    endif
    call add(l:families[l:family], l:path)
  endfor

  let l:result = {}

  for l:family in keys(l:families)
    let l:items = l:families[l:family]

    let l:k2 = {}
    let l:k3 = {}

    for l:path in l:items
      let l:key2 = s:ParentKey(l:path, 2)
      let l:key3 = s:ParentKey(l:path, 3)
      let l:k2[l:key2] = 1
      let l:k3[l:key3] = 1
    endfor

    let l:n2 = len(keys(l:k2))
    let l:n3 = len(keys(l:k3))

    " Heuristic:
    " - use depth 2 if it already gives enough separation
    " - use depth 3 only if it adds meaningful extra separation
    "
    " In practice:
    "   packages/foo vs packages/bar => depth 2
    "   apps/broker/x vs apps/broker/y => depth 3
    if l:n2 >= 2
      let l:result[l:family] = 2
    elseif l:n3 > l:n2
      let l:result[l:family] = 3
    else
      let l:result[l:family] = 2
    endif
  endfor

  return l:result
endfunction

function! FugitiveClearPathMatches() abort
  if exists('b:fugitive_path_match_ids')
    for id in b:fugitive_path_match_ids
      call matchdelete(id)
    endfor
  endif
  let b:fugitive_path_match_ids = []
endfunction

function! FugitiveHighlightPathsSmart() abort
  if &filetype !=# 'fugitive'
    return
  endif

  call FugitiveClearPathMatches()

  let l:groups = [
        \ 'FugitivePath1',
        \ 'FugitivePath2',
        \ 'FugitivePath3',
        \ 'FugitivePath4',
        \ 'FugitivePath5',
        \ 'FugitivePath6',
        \ 'FugitivePath7',
        \ 'FugitivePath8',
        \ 'FugitivePath9',
        \ ]

  " First pass: collect status lines and paths
  let l:entries = []
  let l:paths = []

  for lnum in range(1, line('$'))
    let l:line = getline(lnum)
    let l:path = s:FugitiveExtractPath(l:line)
    if empty(l:path)
      continue
    endif
    call add(l:entries, {'lnum': lnum, 'path': l:path})
    call add(l:paths, l:path)
  endfor

  if empty(l:entries)
    return
  endif

  let l:depth_by_family = s:ChooseDepthByFamily(l:paths)

  let l:key_to_group = {}
  let l:next_idx = 0

  " Second pass: assign colors using chosen family depth
  for l:item in l:entries
    let l:path = l:item.path
    let l:family = s:FamilyRoot(l:path)
    let l:depth = get(l:depth_by_family, l:family, 2)
    let l:key = s:ParentKey(l:path, l:depth)

    if empty(l:key)
      let l:key = '[root]'
    endif

    if !has_key(l:key_to_group, l:key)
      let l:key_to_group[l:key] = l:groups[l:next_idx % len(l:groups)]
      let l:next_idx += 1
    endif

    let l:hl = l:key_to_group[l:key]
    let l:pat = '\%' . l:item.lnum . 'l\s\+\zs\V' . escape(l:path, '\')

    let l:id = matchadd(l:hl, l:pat)
    call add(b:fugitive_path_match_ids, l:id)
  endfor
endfunction

augroup FugitivePathColors
  autocmd!
  autocmd BufEnter,WinEnter,CursorHold * if &filetype ==# 'fugitive' | call FugitiveHighlightPathsSmart() | endif
augroup END
