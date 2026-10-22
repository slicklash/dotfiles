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

var pkg_root_cache: dict<string> = {}

def GetWorkTree(): string
  # g: prefix keeps the lookup at runtime; an unqualified call would be
  # resolved when this def is compiled, before fugitive is loaded.
  if exists('*g:FugitiveWorkTree')
    var tree = g:FugitiveWorkTree()
    if !empty(tree)
      return tree
    endif
  endif
  return getcwd()
enddef

def FindPackageRoot(worktree: string, path: string): string
  # Nearest ancestor dir holding a package.json, worktree-relative.
  # The worktree root itself never matches, so repo-root files (docs/,
  # .vscode/, ...) fall through to the depth heuristic instead of
  # collapsing into a single color.
  var dirs = GetParentDirs(path)
  var pending: list<string> = []
  var found = ''

  while !empty(dirs)
    var rel = join(dirs, '/')
    var abs = worktree .. '/' .. rel
    if has_key(pkg_root_cache, abs)
      found = pkg_root_cache[abs]
      break
    endif
    if filereadable(abs .. '/package.json')
      found = rel
      pkg_root_cache[abs] = rel
      break
    endif
    add(pending, abs)
    remove(dirs, -1)
  endwhile

  for dir_abs in pending
    pkg_root_cache[dir_abs] = found
  endfor

  return found
enddef

def ChooseDepthByFamily(paths: list<string>): dict<number>
  # Fallback grouping for paths outside any package.
  # Returns dict: family_root -> chosen depth
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

    var maxdepth = 1
    for path in items
      maxdepth = max([maxdepth, len(GetParentDirs(path))])
    endfor

    # Heuristic: use the shallowest depth that actually separates the
    # family, i.e. the depth at which its paths first diverge.
    #
    # In practice:
    #   packages/foo vs packages/bar               => depth 2
    #   apps/broker/x vs apps/broker/y             => depth 3
    #   apps/broker/system/{private,public}        => depth 4
    #   .../src/app/{issuers,parties}              => depth 7
    #
    # Families that never diverge (single subtree) stay at depth 2 and
    # share one color.
    var depth = 2
    for d in range(2, maxdepth)
      var seen: dict<number> = {}
      for path in items
        seen[GetParentKey(path, d)] = 1
      endfor
      if len(keys(seen)) >= 2
        depth = d
        break
      endif
    endfor

    result[family] = depth
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

  # Second pass: one color per package root, so everything inside a
  # single app/package shares a color no matter how deep it sits.
  var worktree = GetWorkTree()
  var roots: dict<string> = {}
  var unpackaged: list<string> = []

  for path in paths
    var root = FindPackageRoot(worktree, path)
    roots[path] = root
    if empty(root)
      add(unpackaged, path)
    endif
  endfor

  var depth_by_family = ChooseDepthByFamily(unpackaged)

  var key_to_group: dict<string> = {}
  var next_idx = 0

  for item in entries
    var path = item.path
    var key = roots[path]

    if empty(key)
      var family = GetFamilyRoot(path)
      var depth = get(depth_by_family, family, 2)
      key = GetParentKey(path, depth)
    endif

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
