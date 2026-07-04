vim9script

var missing = g:Missing('rg', 'fd')
if !empty(missing)
  echo 'Error while processing ' .. resolve(expand('<sfile>:p'))
  echo 'Error: missing ' .. missing
  cquit
endif

dein#add('vim-fuzzbox/fuzzbox.vim', {'rev': '7e9c7211abf7c9f8717eb58b7846e8bfcfb7fa01'})

g:fuzzbox_mappings = 0
g:fuzzbox_dropdown = 1
g:fuzzbox_preview = 1
g:fuzzbox_preview_cutoff = 90
g:fuzzbox_compact = 1

g:fuzzbox_keymaps = {
      \ 'menu_up': ["\<C-p>", "\<Up>", "\<C-k>"],
      \ 'menu_down': ["\<C-n>", "\<Down>", "\<C-j>"],
      \ }

g:fuzzbox_window_defaults = {'width': 0.9, 'height': 0.8, 'preview_ratio': 0.5}

var quickfix_on_enter = false

# rows marked with <Tab> in the current picker
var marks: list<string> = []
var menu_wid = -1

def Setup()
  nnoremap <Space>f <ScriptCmd>g:FuzzyFind()<CR>
  nnoremap <Space>F <ScriptCmd>g:FuzzyFind({'ft': '?'})<CR>
  nnoremap <Space>p <ScriptCmd>g:FuzzyFind({'dir': g:GetProjectDir()})<CR>
  nnoremap <Space>m <ScriptCmd>SearchModules()<CR>
  nnoremap <Space>A <ScriptCmd>g:FuzzyFind({'dir': g:GetProjectDir(), 'ft': '?'})<CR>

  nnoremap <Space>g <ScriptCmd>SearchGit({'source': 'git log'})<CR>
  nnoremap <Space>o <ScriptCmd>SearchGit({'source': 'git log', 'preview_args': '--name-only'})<CR>

  nnoremap <Space>c <ScriptCmd>g:FuzzyFind({'dir': '~/.vim/', 'ignore': ['.cache', 'cache', 'bundle*', '.dein', 'tmp']})<CR>
  nnoremap <Space>z <ScriptCmd>g:FuzzyFind({'dir': '~/.zsh/'})<CR>
  nnoremap <Space>` <ScriptCmd>g:FuzzyFind({'dir': '~/'})<CR>

  nnoremap <Space>b <ScriptCmd>FuzzyBufferList()<CR>

  nnoremap <Space>d <ScriptCmd>g:FuzzyFind({'dir': expand('%:p:h')})<CR>
  nnoremap <Space>h <ScriptCmd>FuzzyHelpTags()<CR>
  nnoremap <Space>t <ScriptCmd>FuzzyBufferTags()<CR>
  nnoremap <Space>r <ScriptCmd>FuzzyRecent()<CR>
  nnoremap <Space>; <ScriptCmd>FuzzyCommandHistory()<CR>

  nnoremap <Leader>fd <ScriptCmd>g:FuzzyFind({'grep': expand('<cword>')})<CR>
  nnoremap <Leader>fa <ScriptCmd>g:FuzzyFind({'grep': expand('<cword>'), 'dir': g:GetProjectDir()})<CR>

  nnoremap <Space>/ <ScriptCmd>g:SearchIn('')<CR>
  nnoremap <Space>s <ScriptCmd>g:SearchIn('')<CR>
  nnoremap <Space>? <ScriptCmd>g:SearchIn('', null_string, {'ft': '?'})<CR>
  nnoremap <Space>\ <ScriptCmd>g:SearchIn(g:GetProjectDir())<CR>
  nnoremap <Space>\| <ScriptCmd>g:SearchIn(g:GetProjectDir(), null_string, {'ft': '?'})<CR>
enddef

autocmd User InitPost ++once Setup()

def GetDefaultIgnores(): list<string>
  return [
        \ '.codex/.tmp',
        \ '.git',
        \ '.git-dotfiles',
        \ '__pycache__',
        \ '.venv',
        \ '.turbo',
        \ '.mypy_cache',
        \ '.pytest_cache',
        \ '.DS_Store',
        \ 'node_modules',
        \ 'target',
        \ 'dist',
        \ 'bin/main',
        \ 'bin/test',
        \ 'build/src',
        \ 'build/classes',
        \ 'build/generated',
        \ 'build/resources',
        \ 'htmlcov/',
        \ 'Library/',
        \ '.Trash/',
        \ '*.tsbuildinfo',
        \ '.cache',
        \ '.npm',
        \ '.cargo',
        \ '.rustup',
        \ '.choosenim',
        \ '.nimble',
        \ '.zsh_sessions',
        \ 'go/pkg',
        \ ]
enddef

def GetRgCommand(ignores: list<string>, ...extra: list<string>): string
  var rg_options = extend(['rg', '--hidden', '--no-ignore-vcs', '--column', '--line-number', '--no-heading', '--smart-case'], extra)
  for item in ignores
    extend(rg_options, ['--glob', "'!" .. item .. "'"])
  endfor
  return join(rg_options, ' ')
enddef

def StripAnsi(line: string): string
  return substitute(line, '\%x1b\[[0-9;?]*[ -/]*[@-~]', '', 'g')
enddef

def NormalizeDir(dir: string): string
  return empty(dir) ? '' : fnamemodify(expand(dir), ':p')
enddef

def RunLines(command: string, dir: string): list<string>
  var ndir = NormalizeDir(dir)
  var cmd = empty(ndir) ? command : 'cd ' .. shellescape(ndir) .. ' && ' .. command
  var lines = systemlist(cmd)
  if v:shell_error != 0
    g:EchoHi(join(lines, "\n"), 'ErrorMsg')
    return []
  endif
  return filter(map(lines, (_, v) => StripAnsi(v)), (_, v) => !empty(v))
enddef

def GetAbsolutePath(path: string, cwd: string): string
  var p = expand(path)
  if p =~# '^\(/\|[A-Za-z]:[\/\\]\)'
    return fnamemodify(p, ':p')
  endif
  var base = empty(cwd) ? getcwd() : cwd
  return fnamemodify(base .. '/' .. p, ':p')
enddef

def ParsePathResult(result: string, cwd: string): list<any>
  var res = StripAnsi(result)
  var m = matchlist(res, '^\(.\{-}\):\(\d\+\):\(\d\+\):')
  if empty(m)
    var fp = GetAbsolutePath(res, cwd)
    return [fp, 0, 0, fnamemodify(fp, ':t')]
  endif

  var p = GetAbsolutePath(m[1], cwd)
  var lnum = str2nr(m[2])
  var lcol = str2nr(m[3])
  var text = strpart(res, len(m[0]))
  return [p, lnum, lcol, text]
enddef

def JumpTo(lnum: number, lcol: number)
  if lnum <= 0
    return
  endif
  if lcol > 0
    cursor(lnum, lcol)
  else
    execute 'normal! ' .. lnum .. 'G'
  endif
  normal! zz
enddef

def IsInitialEmptyBuffer(): bool
  return winnr('$') == 1
        \ && empty(bufname('%'))
        \ && &buftype ==# ''
        \ && !&modified
        \ && line('$') == 1
        \ && getline(1) ==# ''
enddef

def GetDefaultOpenCmd(): string
  return IsInitialEmptyBuffer() ? 'edit' : 'split'
enddef

def OpenPathResult(cmd: string, result: string, cwd: string)
  if empty(result)
    return
  endif

  var [p, lnum, lcol, text] = ParsePathResult(result, cwd)
  var ocmd = cmd ==# 'default' ? GetDefaultOpenCmd() : cmd
  g:OpenPath(ocmd, fnameescape(p))
  JumpTo(lnum, lcol)
enddef

def SelectPath(cmd: string, wid: number, result: string, opts: dict<any>)
  if quickfix_on_enter
    QuickfixFromMenu(wid, result, opts)
    return
  endif

  OpenPathResult(cmd, result, get(opts, 'cwd', ''))
enddef

def ActionPath(cmd: string, wid: number, result: string, opts: dict<any>)
  silent! popup_close(wid)
  OpenPathResult(cmd, result, get(opts, 'cwd', ''))
enddef

# Wrappers so fuzzbox's inspect.Signature() can detect callback arg counts.
# def functions don't support function('s:name', [args]) partial application,
# so each bound variant gets its own wrapper with the (wid, result, opts) signature.
def SelectPathDefault(wid: number, result: string, opts: dict<any>)
  SelectPath('default', wid, result, opts)
enddef

def ActionPathSplit(wid: number, result: string, opts: dict<any>)
  ActionPath('split', wid, result, opts)
enddef

def ActionPathVsplit(wid: number, result: string, opts: dict<any>)
  ActionPath('vsplit', wid, result, opts)
enddef

def ActionPathTabedit(wid: number, result: string, opts: dict<any>)
  ActionPath('tabedit', wid, result, opts)
enddef

def ResetMarks()
  marks = []
  menu_wid = -1
enddef

def RefreshMarks()
  if menu_wid <= 0 || empty(getwininfo(menu_wid))
    return
  endif
  # drop only our own highlights, keep fuzzbox's fuzzy-match highlighting.
  setmatches(filter(getmatches(menu_wid),
        \ (_, m) => get(m, 'group', '') !=# 'fuzzboxMarked'), menu_wid)
  if empty(marks)
    fuzzbox#popup#SetTitle(menu_wid, '')
    return
  endif

  var lines = getbufline(winbufnr(menu_wid), 1, '$')
  var positions: list<list<number>> = []
  var lnum = 0
  for line in lines
    lnum += 1
    if index(marks, line) >= 0
      add(positions, [lnum])
    endif
  endfor
  # matchaddpos() accepts at most 8 positions per call before patch-9.0.0622.
  var idx = 0
  while idx < len(positions)
    matchaddpos('fuzzboxMarked', positions[idx : idx + 7], 10, -1, {'window': menu_wid})
    idx += 8
  endwhile
  fuzzbox#popup#SetTitle(menu_wid, len(marks) .. ' selected')
enddef

def ToggleMark(wid: number, result: string, opts: dict<any>)
  menu_wid = wid
  if !empty(result)
    var i = index(marks, result)
    if i >= 0
      remove(marks, i)
    else
      add(marks, result)
    endif
  endif
  RefreshMarks()
  win_execute(wid, 'normal! j')
enddef

def BuildQuickfix(lines: list<string>, cwd: string)
  var qf: list<dict<any>> = []
  for line in lines
    if empty(line)
      continue
    endif
    var [p, lnum, lcol, text] = ParsePathResult(line, cwd)
    add(qf, {
          \ 'filename': p,
          \ 'lnum': max([lnum, 1]),
          \ 'col': max([lcol, 1]),
          \ 'text': text,
          \ })
  endfor
  setqflist(qf)
enddef

def QuickfixFromMenu(wid: number, result: string, opts: dict<any>)
  quickfix_on_enter = false
  var cwd: string = get(opts, 'cwd', '')
  # prefer the rows marked with <Tab>; fall back to the full filtered list.
  var lines = empty(marks) ? getbufline(winbufnr(wid), 1, '$') : copy(marks)
  var title = empty(marks) ? 'Fuzzbox (all)' : 'Fuzzbox (' .. len(marks) .. ' selected)'
  BuildQuickfix(lines, cwd)
  setqflist([], 'a', {'title': title})
  silent! popup_close(wid)
  copen
enddef

def ResetQuickfixOnEnter(wid: number)
  quickfix_on_enter = false
  ResetMarks()
enddef

def GetPathActions(): dict<func>
  return {
        \ "\<Tab>": ToggleMark,
        \ "\<c-q>": QuickfixFromMenu,
        \ "\<c-s>": ActionPathSplit,
        \ "\<c-l>": ActionPathVsplit,
        \ "\<c-v>": ActionPathVsplit,
        \ "\<c-n>": ActionPathTabedit,
        \ "\<c-t>": ActionPathTabedit,
        \ }
enddef

def PreviewFile(wid: number, path: string, lnum: number, ...rest: list<any>)
  if wid == -1
    return
  endif

  var lcol = get(rest, 0, 0)
  fuzzbox#internal#previewer#PreviewFile(wid, fnamemodify(path, ':p'), lnum, lcol)
enddef

def PreviewPath(wid: number, result: string, opts: dict<any>)
  RefreshMarks()
  if empty(result)
    popup_settext(wid, [''])
    return
  endif

  var [p, lnum, lcol, text] = ParsePathResult(result, get(opts, 'cwd', ''))
  PreviewFile(wid, p, lnum, lcol)
enddef

def SelectPaths(items: list<string>, opts: dict<any>)
  quickfix_on_enter = false
  ResetMarks()
  var merged = extend({
        \ 'title': 'Find Files',
        \ 'cwd': '',
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'select_cb': SelectPathDefault,
        \ 'preview_cb': PreviewPath,
        \ 'close_cb': ResetQuickfixOnEnter,
        \ 'actions': GetPathActions(),
        \ }, opts)
  fuzzbox#Select(items, merged)
enddef

def FindSpec(params: dict<any> = {}): dict<any>
  var dir: string = get(params, 'dir', '')
  var source: string = get(params, 'source', '')
  var grep: string = get(params, 'grep', '')
  var ft: string = get(params, 'ft', '')

  if empty(ft)
    var tmp = matchstr(grep, '--ft=\S\+')
    if !empty(tmp)
      ft = substitute(tmp, '^--ft=', '', '')
      grep = trim(substitute(grep, '\V' .. escape(tmp, '\'), '', ''))
    endif
  endif

  if empty(source)
    var ignore: list<string> = get(params, 'ignore', GetDefaultIgnores())
    source = empty(grep) ? GetRgCommand(ignore, '--files') : GetRgCommand(ignore)
    if !empty(ft)
      if ft ==# '?'
        ft = input('Type: ')
      endif
      if !empty(ft)
        source ..= ' -t ' .. shellescape(ft)
      endif
    endif
  endif

  if !empty(grep)
    source ..= ' -- ' .. shellescape(grep)
  endif

  return {
        \ 'dir': NormalizeDir(dir),
        \ 'source': source,
        \ 'grep': grep,
        \ }
enddef

# Public entry points (also called from other scripts, e.g. fern), so global.
def g:FuzzyFind(params: dict<any> = {})
  var spec = FindSpec(params)
  var items = RunLines(spec.source, spec.dir)
  var title = empty(spec.grep) ? 'Find Files' : 'Search: ' .. spec.grep
  SelectPaths(items, {'title': title, 'cwd': spec.dir})
enddef

def g:SearchIn(dir: string, pattern: string = null_string, options: dict<any> = {})
  var pat = pattern == null_string ? input('Pattern: ') : pattern
  if empty(pat)
    return
  endif
  g:FuzzyFind(extend({'grep': pat, 'dir': dir}, options))
enddef

def SearchModules()
  g:FuzzyFind({'dir': g:GetProjectDir() .. '/node_modules'})
enddef

def GetBufferItems(): list<string>
  var buffers = getbufinfo({'buflisted': 1})
  sort(buffers, (a, b) => a.lastused == b.lastused ? 0 : a.lastused < b.lastused ? 1 : -1)
  var width = len(string(bufnr('$')))
  return mapnew(buffers, (_, val) => printf(' %' .. width .. 'd %s %s',
        \ val.bufnr,
        \ (val.bufnr == bufnr('') ? '%' : val.bufnr == bufnr('#') ? '#' : ' ') .. (val.changed ? '+' : ' '),
        \ empty(val.name) ? '[No Name]' : fnamemodify(val.name, ':~:.')))
enddef

def GetBufferNumber(result: string): number
  return str2nr(matchstr(result, '^\s*\zs\d\+'))
enddef

def OpenBuffer(cmd: string, result: string)
  var bnr = GetBufferNumber(result)
  if bnr <= 0
    return
  endif

  var ocmd = cmd ==# 'default' ? GetDefaultOpenCmd() : cmd
  if ocmd ==# 'tabedit'
    tabnew
  elseif ocmd ==# 'vsplit'
    vsplit
  elseif ocmd ==# 'split'
    split
  endif
  execute 'buffer ' .. bnr
enddef

def SelectBuffer(cmd: string, wid: number, result: string, opts: dict<any>)
  OpenBuffer(cmd, result)
enddef

def ActionBuffer(cmd: string, wid: number, result: string, opts: dict<any>)
  silent! popup_close(wid)
  OpenBuffer(cmd, result)
enddef

# Buffer action wrappers (same reason as path wrappers above).
def SelectBufferDefault(wid: number, result: string, opts: dict<any>)
  SelectBuffer('default', wid, result, opts)
enddef

def ActionBufferSplit(wid: number, result: string, opts: dict<any>)
  ActionBuffer('split', wid, result, opts)
enddef

def ActionBufferVsplit(wid: number, result: string, opts: dict<any>)
  ActionBuffer('vsplit', wid, result, opts)
enddef

def ActionBufferTabedit(wid: number, result: string, opts: dict<any>)
  ActionBuffer('tabedit', wid, result, opts)
enddef

def PreviewBuffer(wid: number, result: string, opts: dict<any>)
  var bnr = GetBufferNumber(result)
  if wid == -1 || bnr <= 0
    return
  endif

  var name = bufname(bnr)
  fuzzbox#popup#SetTitle(wid, empty(name) ? '[No Name]' : fnamemodify(name, ':t'))
  if !empty(name) && filereadable(name)
    PreviewFile(wid, fnamemodify(name, ':p'), getbufinfo(bnr)[0].lnum)
  else
    popup_settext(wid, getbufline(bnr, 1, '$'))
  endif
enddef

def GetBufferActions(): dict<func>
  return {
        \ "\<c-s>": ActionBufferSplit,
        \ "\<c-l>": ActionBufferVsplit,
        \ "\<c-v>": ActionBufferVsplit,
        \ "\<c-n>": ActionBufferTabedit,
        \ "\<c-t>": ActionBufferTabedit,
        \ }
enddef

def FuzzyBufferList()
  fuzzbox#Select(GetBufferItems(), {
        \ 'title': 'Buffers',
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'select_cb': SelectBufferDefault,
        \ 'preview_cb': PreviewBuffer,
        \ 'actions': GetBufferActions(),
        \ })
enddef

def GetRecentItems(dir: string): list<string>
  var ndir = NormalizeDir(dir)
  var seen: dict<number> = {}
  var paths: list<string> = []
  for buf in getbufinfo({'buflisted': 1})
    if filereadable(buf.name)
      var p = fnamemodify(buf.name, ':p')
      seen[p] = 1
      add(paths, p)
    endif
  endfor
  for file in v:oldfiles
    var p = fnamemodify(file, ':p')
    if filereadable(p) && !has_key(seen, p)
      seen[p] = 1
      add(paths, p)
    endif
  endfor
  if !empty(ndir)
    filter(paths, (_, v) => stridx(v, ndir) == 0)
  endif
  return map(paths, (_, v) => fnamemodify(v, ':~'))
enddef

def FuzzyRecent(params: dict<any> = {})
  SelectPaths(GetRecentItems(get(params, 'dir', '')), {
        \ 'title': 'Recent Files',
        \ 'cwd': '',
        \ })
enddef

var buftags_file = ''

def BufferTagLnum(result: string): number
  return str2nr(matchstr(result, '\d\+\s*$'))
enddef

def GetBufferTagLines(file: string): list<string>
  var cmd = 'ctags -f - --excmd=number --sort=no --fields=+nKs ' .. shellescape(file)
  var raw = systemlist(cmd)
  if v:shell_error != 0
    g:EchoHi(join(raw, "\n"), 'ErrorMsg')
    return []
  endif

  var rows: list<dict<any>> = []
  var namew = 0
  var kindw = 0
  for line in raw
    if empty(line) || line[0] ==# '!'
      continue
    endif
    var parts = split(line, "\t")
    if len(parts) < 3
      continue
    endif
    var lnum = str2nr(matchstr(parts[2], '^\d\+'))
    if lnum <= 0
      continue
    endif
    var name = parts[0]
    var kind = get(parts, 3, '')
    var scope = ''
    for field in parts[4 : ]
      if field !~# '^\(line\|typeref\):' && field =~# ':'
        scope = substitute(field, '^[^:]*:', '', '')
        break
      endif
    endfor
    namew = max([namew, len(name)])
    kindw = max([kindw, len(kind)])
    add(rows, {name: name, kind: kind, scope: scope, lnum: lnum})
  endfor

  var fmt = '%-' .. (namew + 2) .. 's%-' .. (kindw + 2) .. 's%-28s%6d'
  return mapnew(rows, (_, r) => printf(fmt, r.name, r.kind, r.scope, r.lnum))
enddef

def SelectBufferTag(wid: number, result: string, opts: dict<any>)
  if empty(result)
    return
  endif
  var lnum = BufferTagLnum(result)
  if lnum > 0
    JumpTo(lnum, 0)
  endif
enddef

def PreviewBufferTag(wid: number, result: string, opts: dict<any>)
  if wid == -1 || empty(result)
    return
  endif
  PreviewFile(wid, buftags_file, BufferTagLnum(result))
enddef

def FuzzyBufferTags()
  var file = expand('%:p')
  if empty(file) || !filereadable(file)
    g:EchoHi('No file on disk to read tags from', 'WarningMsg')
    return
  endif
  buftags_file = file
  var lines = GetBufferTagLines(file)
  if empty(lines)
    echo 'No tags in ' .. fnamemodify(file, ':t')
    return
  endif
  fuzzbox#Select(lines, {
        \ 'title': fnamemodify(file, ':t') .. ' tags',
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'select_cb': SelectBufferTag,
        \ 'preview_cb': PreviewBufferTag,
        \ })
enddef

def FuzzyHelpTags()
  execute 'FuzzyHelp'
enddef

def FuzzyCommandHistory()
  execute 'FuzzyCmdHistory'
enddef

def GetGitHash(result: string): string
  return matchstr(result, '[a-f0-9]\{7,\}')
enddef

def PreviewGit(wid: number, result: string, opts: dict<any>)
  if wid == -1
    return
  endif
  var hash = GetGitHash(result)
  if empty(hash)
    popup_settext(wid, ['No valid commit selected'])
    return
  endif

  var dir: string = get(opts, 'cwd', getcwd())
  var preview_args: string = get(opts, 'git_preview_args', '')
  var cmd = 'git -C ' .. shellescape(dir) .. ' show --color=never ' .. preview_args .. ' ' .. shellescape(hash)
  fuzzbox#popup#SetTitle(wid, hash)
  popup_settext(wid, systemlist(cmd))
  win_execute(wid, 'setlocal syntax=diff')
enddef

def GitNoop(wid: number, result: string, opts: dict<any>)
enddef

def GitFixup(wid: number, result: string, opts: dict<any>)
  var hash = GetGitHash(result)
  if !empty(hash)
    silent! popup_close(wid)
    var cmd = 'git commit --fixup=' .. hash
    execute 'silent !' .. cmd
    redraw!
    g:EchoHi(cmd)
  endif
enddef

def GitAutosquash(wid: number, result: string, opts: dict<any>)
  var hash = GetGitHash(result)
  if !empty(hash)
    silent! popup_close(wid)
    var cmd = 'zsh -i -c ''git rebase -i --autosquash --autostash ' .. hash .. ';exec zsh'''
    execute 'silent !tmux splitw -v "' .. cmd .. '"'
  endif
enddef

def GetGitActions(): dict<func>
  return {
        \ "\<c-f>": GitFixup,
        \ "\<c-s>": GitAutosquash,
        \ }
enddef

def SearchGit(params: dict<any> = {})
  var source: string = get(params, 'source', 'git log')
  var dir = NormalizeDir(get(params, 'dir', getcwd()))

  var git_log_format: string = get(params, 'format', '%h %>(12,trunc)%cr %d %s %an')
  var git_log_args: string = get(params, 'source_args', '--abbrev=7 --oneline --format=' .. shellescape(git_log_format))
  if source ==# 'git log'
    source = source .. ' ' .. git_log_args
  endif

  var items = RunLines(source, dir)
  fuzzbox#Select(items, {
        \ 'title': 'Git',
        \ 'cwd': dir,
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'preview_cb': PreviewGit,
        \ 'select_cb': GitNoop,
        \ 'actions': GetGitActions(),
        \ 'git_preview_args': get(params, 'preview_args', ''),
        \ })
enddef
