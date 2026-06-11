vim9script

dein#add('tpope/vim-fugitive', {'rev': '3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0'})

def Setup()
  nnoremap <silent> <leader>gg <cmd>Git<cr>
  nnoremap <silent> <leader>gb <cmd>Gblame<cr>
  nnoremap <silent> <leader>gm  <cmd>Gvdiffsplit main<cr>
enddef

autocmd User InitPost ++once Setup()

def g:FugitiveOpenFile()
  var path = expand('<cfile>')
  if empty(path)
    return
  endif
  var cwd = split(getcwd(), '/')[-1]
  var n = stridx(path, cwd)
  path = strpart(path, n + len(cwd) + 1)
  wincmd k
  execute printf('noswapfile vsplit %s', path)
enddef

def g:FuView()
  var cwd = split(getcwd(), '/')
  var curline = strpart(getline('.'), 2)
  var i = 0
  for idx in range(len(cwd) - 1)
    i = idx
    var prefix = join(slice(cwd, idx), '/')
    if stridx(curline, prefix) == 0
      break
    endif
  endfor
  var path = '/' .. join(slice(cwd, 0, i), '/') .. '/' .. curline
  echo path
  execute 'silent !xdg-open ' .. path .. '> /dev/null 2>&1 &'
  redraw!
enddef

autocmd User FugitiveIndex nnoremap <buffer> E <cmd>call FuView()<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete

def FugitiveNormalizePath(path: string): string
  var p = path
  if p =~# ' -> '
    p = substitute(p, '^.* -> ', '', '')
  endif
  return p
enddef

def FugitiveExtractPath(line: string): string
  var m = matchlist(line, '^\s*[MADRCU?!T]\+\s\+\(.*\)$')
  if empty(m)
    return ''
  endif
  return FugitiveNormalizePath(m[1])
enddef

def GetParentDirs(path: string): list<string>
  var parts = split(path, '/')
  if len(parts) <= 1
    return []
  endif
  return parts[: -2]
enddef

def GetParentKey(path: string, depth: number): string
  var dirs = GetParentDirs(path)
  if empty(dirs)
    return ''
  endif
  var endd = min([len(dirs), depth]) - 1
  return join(dirs[: endd], '/')
enddef

def GetFamilyRoot(path: string): string
  var dirs = GetParentDirs(path)
  if empty(dirs)
    return ''
  endif
  if len(dirs) == 1
    return dirs[0]
  endif
  return join(dirs[: 1], '/')
enddef

def ChooseDepthByFamily(paths: list<string>): dict<number>
  # Returns dict: family_root -> chosen depth (2 or 3)
  var families: dict<list<string>> = {}

  for path in paths
    var family = GetFamilyRoot(path)
    if !has_key(families, family)
      families[family] = []
    endif
    add(families[family], path)
  endfor

  var result: dict<number> = {}

  for family in keys(families)
    var items = families[family]

    var k2: dict<number> = {}
    var k3: dict<number> = {}

    for path in items
      var key2 = GetParentKey(path, 2)
      var key3 = GetParentKey(path, 3)
      k2[key2] = 1
      k3[key3] = 1
    endfor

    var n2 = len(keys(k2))
    var n3 = len(keys(k3))

    # Heuristic:
    # - use depth 2 if it already gives enough separation
    # - use depth 3 only if it adds meaningful extra separation
    #
    # In practice:
    #   packages/foo vs packages/bar => depth 2
    #   apps/broker/x vs apps/broker/y => depth 3
    if n2 >= 2
      result[family] = 2
    elseif n3 > n2
      result[family] = 3
    else
      result[family] = 2
    endif
  endfor

  return result
enddef

def g:FugitiveClearPathMatches()
  if exists('b:fugitive_path_match_ids')
    for id in b:fugitive_path_match_ids
      matchdelete(id)
    endfor
  endif
  b:fugitive_path_match_ids = []
enddef

def g:FugitiveHighlightPathsSmart()
  if &filetype !=# 'fugitive'
    return
  endif

  g:FugitiveClearPathMatches()

  var groups = [
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

  # First pass: collect status lines and paths
  var entries: list<dict<any>> = []
  var paths: list<string> = []

  for lnum in range(1, line('$'))
    var line = getline(lnum)
    var path = FugitiveExtractPath(line)
    if empty(path)
      continue
    endif
    add(entries, {'lnum': lnum, 'path': path})
    add(paths, path)
  endfor

  if empty(entries)
    return
  endif

  var depth_by_family = ChooseDepthByFamily(paths)

  var key_to_group: dict<string> = {}
  var next_idx = 0

  # Second pass: assign colors using chosen family depth
  for item in entries
    var path = item.path
    var family = GetFamilyRoot(path)
    var depth = get(depth_by_family, family, 2)
    var key = GetParentKey(path, depth)

    if empty(key)
      key = '[root]'
    endif

    if !has_key(key_to_group, key)
      key_to_group[key] = groups[next_idx % len(groups)]
      next_idx += 1
    endif

    var hl = key_to_group[key]
    var pat = '\%' .. item.lnum .. 'l\s\+\zs\V' .. escape(path, '\')

    var id = matchadd(hl, pat)
    add(b:fugitive_path_match_ids, id)
  endfor
enddef

augroup FugitivePathColors
  autocmd!
  autocmd BufEnter,WinEnter,CursorHold * g:FugitiveHighlightPathsSmart()
augroup END
