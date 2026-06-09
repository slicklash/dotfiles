let missing = Missing('rg')
if !empty(missing)
  echo 'Error while processing ' . resolve(expand('<sfile>:p'))
  echo 'Error: missing '.missing
  cquit
endif

let g:fuzzy_search_backend = get(g:, 'fuzzy_search_backend', 'fuzzbox')
if g:fuzzy_search_backend !=# 'fuzzbox'
  finish
endif

call dein#add('vim-fuzzbox/fuzzbox.vim', { 'rev': 'b0f0fd3b947e57143fa8a2634418bd9a689c58f8' })

let g:fuzzbox_mappings = 0
let g:fuzzbox_dropdown = 1
let g:fuzzbox_preview = 1
let g:fuzzbox_preview_cutoff = 90
let g:fuzzbox_compact = 1

let g:fuzzbox_keymaps = {
      \ 'menu_up': ["\<C-p>", "\<Up>", "\<C-k>"],
      \ 'menu_down': ["\<C-n>", "\<Down>", "\<C-j>"],
      \ }

let g:fuzzbox_window_defaults = { 'width': 0.9, 'height': 0.8, 'preview_ratio': 0.5 }

let s:quickfix_on_enter = v:false

" rows marked with <Tab> in the current picker
let s:marks = []
let s:menu_wid = -1

function! s:setup() abort
  nnoremap <Space>f <cmd>call FuzzyFind()<CR>
  nnoremap <Space>F <cmd>call FuzzyFind({'ft': '?'})<CR>
  nnoremap <Space>p <cmd>call FuzzyFind({'dir': GetProjectDir()})<CR>
  nnoremap <Space>m <cmd>call SearchModules()<CR>
  nnoremap <Space>A <cmd>call FuzzyFind({'dir': GetProjectDir(), 'ft': '?'})<CR>

  nnoremap <Space>g <cmd>call SearchGit({'source': 'git log'})<CR>
  nnoremap <Space>o <cmd>call SearchGit({'source': 'git log', 'preview_args': '--name-only'})<CR>

  nnoremap <Space>c <cmd>call FuzzyFind({'dir': '~/.vim/', 'ignore':['.cache', 'cache', 'bundle*', '.dein', 'tmp']})<CR>
  nnoremap <Space>z <cmd>call FuzzyFind({'dir': '~/.zsh/'})<CR>
  nnoremap <Space>` <cmd>call FuzzyFind({'dir': '~/'})<CR>

  nnoremap <Space>b <cmd>call FuzzyBufferList()<CR>

  nnoremap <Space>d <cmd>call FuzzyFind({'dir': expand('%:p:h')})<CR>
  nnoremap <Space>h <cmd>call FuzzyHelpTags()<CR>
  nnoremap <Space>r <cmd>call FuzzyRecent()<CR>
  nnoremap <Space>; <cmd>call FuzzyCommandHistory()<CR>

  nnoremap <Leader>fd <cmd>call FuzzyFind({'grep': expand('<cword>')})<CR>
  nnoremap <Leader>fa <cmd>call FuzzyFind({'grep': expand('<cword>'), 'dir': GetProjectDir()})<CR>

  nnoremap <Space>/ <cmd>call SearchIn('')<CR>
  nnoremap <Space>s <cmd>call SearchIn('')<CR>
  nnoremap <Space>? <cmd>call SearchIn('', v:none, {'ft': '?'})<CR>
  nnoremap <Space>\ <cmd>call SearchIn(GetProjectDir())<CR>
  nnoremap <Space>\| <cmd>call SearchIn(GetProjectDir(), v:none, {'ft': '?'})<CR>
endfunction

autocmd User InitPost ++once call s:setup()

function! s:default_ignores() abort
  return [
        \ '.git',
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
        \ ]
endfunction

function! _rg(ignores, ...) abort
  let l:rg_options = extend(['rg', '--hidden', '--no-ignore-vcs', '--column', '--line-number', '--no-heading', '--smart-case'], a:000)
  for l:item in a:ignores
    call extend(l:rg_options, ['--glob', "'!" . l:item . "'"])
  endfor
  return join(l:rg_options, ' ')
endfunction

function! s:strip_ansi(line) abort
  return substitute(a:line, '\%x1b\[[0-9;?]*[ -/]*[@-~]', '', 'g')
endfunction

function! s:normalize_dir(dir) abort
  return empty(a:dir) ? '' : fnamemodify(expand(a:dir), ':p')
endfunction

function! s:run_lines(command, dir) abort
  let l:dir = s:normalize_dir(a:dir)
  let l:command = empty(l:dir) ? a:command : 'cd ' . shellescape(l:dir) . ' && ' . a:command
  let l:lines = systemlist(l:command)
  if v:shell_error
    call EchoHi(join(l:lines, "\n"), 'ErrorMsg')
    return []
  endif
  return filter(map(l:lines, 's:strip_ansi(v:val)'), '!empty(v:val)')
endfunction

function! s:absolute_path(path, cwd) abort
  let l:path = expand(a:path)
  if l:path =~# '^\(/\|[A-Za-z]:[\/\\]\)'
    return fnamemodify(l:path, ':p')
  endif
  let l:cwd = empty(a:cwd) ? getcwd() : a:cwd
  return fnamemodify(l:cwd . '/' . l:path, ':p')
endfunction

function! s:parse_path_result(result, cwd) abort
  let l:result = s:strip_ansi(a:result)
  let l:match = matchlist(l:result, '^\(.\{-}\):\(\d\+\):\(\d\+\):')
  if empty(l:match)
    let l:path = s:absolute_path(l:result, a:cwd)
    return [l:path, 0, 0, fnamemodify(l:path, ':t')]
  endif

  let l:path = s:absolute_path(l:match[1], a:cwd)
  let l:line = str2nr(l:match[2])
  let l:col = str2nr(l:match[3])
  let l:text = strpart(l:result, len(l:match[0]))
  return [l:path, l:line, l:col, l:text]
endfunction

function! s:jump_to(line, col) abort
  if a:line <= 0
    return
  endif
  if a:col > 0
    call cursor(a:line, a:col)
  else
    execute 'normal! ' . a:line . 'G'
  endif
  normal! zz
endfunction

function! s:is_initial_empty_buffer() abort
  return winnr('$') == 1
        \ && empty(bufname('%'))
        \ && &buftype ==# ''
        \ && !&modified
        \ && line('$') == 1
        \ && getline(1) ==# ''
endfunction

function! s:default_open_cmd() abort
  return s:is_initial_empty_buffer() ? 'edit' : 'split'
endfunction

function! s:open_path_result(cmd, result, cwd) abort
  if empty(a:result)
    return
  endif

  let [l:path, l:line, l:col, l:text] = s:parse_path_result(a:result, a:cwd)
  let l:cmd = a:cmd ==# 'default' ? s:default_open_cmd() : a:cmd
  call OpenPath(l:cmd, fnameescape(l:path))
  call s:jump_to(l:line, l:col)
endfunction

function! s:select_path(cmd, wid, result, opts) abort
  if s:quickfix_on_enter
    call s:quickfix_from_menu(a:wid, a:result, a:opts)
    return
  endif

  call s:open_path_result(a:cmd, a:result, get(a:opts, 'cwd', ''))
endfunction

function! s:action_path(cmd, wid, result, opts) abort
  silent! call popup_close(a:wid)
  call s:open_path_result(a:cmd, a:result, get(a:opts, 'cwd', ''))
endfunction

function! s:reset_marks() abort
  let s:marks = []
  let s:menu_wid = -1
endfunction

function! s:refresh_marks() abort
  if s:menu_wid <= 0 || empty(getwininfo(s:menu_wid))
    return
  endif
  " drop only our own highlights, keep fuzzbox's fuzzy-match highlighting.
  call setmatches(filter(getmatches(s:menu_wid),
        \ {_, m -> get(m, 'group', '') !=# 'fuzzboxMarked'}), s:menu_wid)
  if empty(s:marks)
    call fuzzbox#popup#SetTitle(s:menu_wid, '')
    return
  endif

  let l:lines = getbufline(winbufnr(s:menu_wid), 1, '$')
  let l:positions = []
  let l:lnum = 0
  for l:line in l:lines
    let l:lnum += 1
    if index(s:marks, l:line) >= 0
      call add(l:positions, [l:lnum])
    endif
  endfor
  " matchaddpos() accepts at most 8 positions per call before patch-9.0.0622.
  let l:idx = 0
  while l:idx < len(l:positions)
    call matchaddpos('fuzzboxMarked', l:positions[l:idx : l:idx + 7], 10, -1, {'window': s:menu_wid})
    let l:idx += 8
  endwhile
  call fuzzbox#popup#SetTitle(s:menu_wid, len(s:marks) . ' selected')
endfunction

function! s:toggle_mark(wid, result, opts) abort
  let s:menu_wid = a:wid
  if !empty(a:result)
    let l:i = index(s:marks, a:result)
    if l:i >= 0
      call remove(s:marks, l:i)
    else
      call add(s:marks, a:result)
    endif
  endif
  call s:refresh_marks()
  call win_execute(a:wid, 'normal! j')
endfunction

function! s:build_quickfix(lines, cwd) abort
  let l:qf = []
  for l:line in a:lines
    if empty(l:line)
      continue
    endif
    let [l:path, l:lnum, l:col, l:text] = s:parse_path_result(l:line, a:cwd)
    call add(l:qf, {
          \ 'filename': l:path,
          \ 'lnum': max([l:lnum, 1]),
          \ 'col': max([l:col, 1]),
          \ 'text': l:text,
          \ })
  endfor
  call setqflist(l:qf)
endfunction

function! s:quickfix_from_menu(wid, result, opts) abort
  let s:quickfix_on_enter = v:false
  let l:cwd = get(a:opts, 'cwd', '')
  " prefer the rows marked with <Tab>; fall back to the full filtered list.
  let l:lines = empty(s:marks) ? getbufline(winbufnr(a:wid), 1, '$') : copy(s:marks)
  let l:title = empty(s:marks) ? 'Fuzzbox (all)' : 'Fuzzbox (' . len(s:marks) . ' selected)'
  call s:build_quickfix(l:lines, l:cwd)
  call setqflist([], 'a', {'title': l:title})
  silent! call popup_close(a:wid)
  copen
endfunction

function! s:reset_quickfix_on_enter(wid) abort
  let s:quickfix_on_enter = v:false
  call s:reset_marks()
endfunction

function! s:path_actions() abort
  return {
        \ "\<Tab>": function('s:toggle_mark'),
        \ "\<c-q>": function('s:quickfix_from_menu'),
        \ "\<c-s>": function('s:action_path', ['split']),
        \ "\<c-l>": function('s:action_path', ['vsplit']),
        \ "\<c-v>": function('s:action_path', ['vsplit']),
        \ "\<c-n>": function('s:action_path', ['tabedit']),
        \ "\<c-t>": function('s:action_path', ['tabedit']),
        \ }
endfunction

function! s:preview_file(wid, path, line, ...) abort
  if a:wid == -1
    return
  endif

  let l:col = get(a:000, 0, 0)
  call fuzzbox#internal#previewer#PreviewFile(a:wid, fnamemodify(a:path, ':p'), a:line, l:col)
endfunction

function! s:preview_path(wid, result, opts) abort
  call s:refresh_marks()
  if empty(a:result)
    call popup_settext(a:wid, [''])
    return
  endif

  let [l:path, l:line, l:col, l:text] = s:parse_path_result(a:result, get(a:opts, 'cwd', ''))
  call s:preview_file(a:wid, l:path, l:line, l:col)
endfunction

function! s:select_paths(items, opts) abort
  let s:quickfix_on_enter = v:false
  call s:reset_marks()
  let l:opts = extend({
        \ 'title': 'Find Files',
        \ 'cwd': '',
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'select_cb': function('s:select_path', ['default']),
        \ 'preview_cb': function('s:preview_path'),
        \ 'close_cb': function('s:reset_quickfix_on_enter'),
        \ 'actions': s:path_actions(),
        \ }, a:opts)
  call fuzzbox#Select(a:items, l:opts)
endfunction

function! s:find_spec(...) abort
  let l:params = get(a:000, 0, {})
  let l:dir = get(l:params, 'dir', '')
  let l:source = get(l:params, 'source', '')
  let l:grep = get(l:params, 'grep', '')
  let l:ft = get(l:params, 'ft', '')

  if empty(l:ft)
    let l:tmp = matchstr(l:grep, '--ft=\S\+')
    if !empty(l:tmp)
      let l:ft = substitute(l:tmp, '^--ft=', '', '')
      let l:grep = trim(substitute(l:grep, '\V' . escape(l:tmp, '\'), '', ''))
    endif
  endif

  if empty(l:source)
    let l:ignore = get(l:params, 'ignore', s:default_ignores())
    let l:source = empty(l:grep) ? _rg(l:ignore, '--files') : _rg(l:ignore)
    if !empty(l:ft)
      if l:ft ==# '?'
        let l:ft = input('Type: ')
      endif
      if !empty(l:ft)
        let l:source .= ' -t ' . shellescape(l:ft)
      endif
    endif
  endif

  if !empty(l:grep)
    let l:source .= ' -- ' . shellescape(l:grep)
  endif

  return {
        \ 'dir': s:normalize_dir(l:dir),
        \ 'source': l:source,
        \ 'grep': l:grep,
        \ }
endfunction

function! FuzzyFind(...) abort
  let l:spec = call('s:find_spec', a:000)
  let l:items = s:run_lines(l:spec.source, l:spec.dir)
  let l:title = empty(l:spec.grep) ? 'Find Files' : 'Search: ' . l:spec.grep
  call s:select_paths(l:items, { 'title': l:title, 'cwd': l:spec.dir })
endfunction

function! SearchIn(dir, ...) abort
  let l:pattern = a:0 > 0 && a:1 != v:none ? a:1 : input('Pattern: ')
  let l:options = get(a:000, 1, {})
  if empty(l:pattern)
    return
  endif
  call FuzzyFind(extend({'grep': l:pattern, 'dir': a:dir}, l:options))
endfunction

function! SearchModules() abort
  call FuzzyFind({'dir': GetProjectDir() . '/node_modules'})
endfunction

function! s:buffer_items() abort
  let l:buffers = getbufinfo({'buflisted': 1})
  call sort(l:buffers, {a, b -> a.lastused == b.lastused ? 0 : a.lastused < b.lastused ? 1 : -1})
  let l:width = len(string(bufnr('$')))
  return map(l:buffers, {
        \ _, val -> printf(' %' . l:width . 'd %s %s',
        \ val.bufnr,
        \ (val.bufnr == bufnr('') ? '%' : val.bufnr == bufnr('#') ? '#' : ' ') . (val.changed ? '+' : ' '),
        \ empty(val.name) ? '[No Name]' : fnamemodify(val.name, ':~:.'))
        \ })
endfunction

function! s:buffer_number(result) abort
  return str2nr(matchstr(a:result, '^\s*\zs\d\+'))
endfunction

function! s:open_buffer(cmd, result) abort
  let l:bufnr = s:buffer_number(a:result)
  if l:bufnr <= 0
    return
  endif

  let l:cmd = a:cmd ==# 'default' ? s:default_open_cmd() : a:cmd
  if l:cmd ==# 'tabedit'
    tabnew
  elseif l:cmd ==# 'vsplit'
    vsplit
  elseif l:cmd ==# 'split'
    split
  endif
  execute 'buffer ' . l:bufnr
endfunction

function! s:select_buffer(cmd, wid, result, opts) abort
  call s:open_buffer(a:cmd, a:result)
endfunction

function! s:action_buffer(cmd, wid, result, opts) abort
  silent! call popup_close(a:wid)
  call s:open_buffer(a:cmd, a:result)
endfunction

function! s:preview_buffer(wid, result, opts) abort
  let l:bufnr = s:buffer_number(a:result)
  if a:wid == -1 || l:bufnr <= 0
    return
  endif

  let l:name = bufname(l:bufnr)
  call fuzzbox#popup#SetTitle(a:wid, empty(l:name) ? '[No Name]' : fnamemodify(l:name, ':t'))
  if !empty(l:name) && filereadable(l:name)
    call s:preview_file(a:wid, fnamemodify(l:name, ':p'), getbufinfo(l:bufnr)[0].lnum)
  else
    call popup_settext(a:wid, getbufline(l:bufnr, 1, '$'))
  endif
endfunction

function! s:buffer_actions() abort
  return {
        \ "\<c-s>": function('s:action_buffer', ['split']),
        \ "\<c-l>": function('s:action_buffer', ['vsplit']),
        \ "\<c-v>": function('s:action_buffer', ['vsplit']),
        \ "\<c-n>": function('s:action_buffer', ['tabedit']),
        \ "\<c-t>": function('s:action_buffer', ['tabedit']),
        \ }
endfunction

function! FuzzyBufferList() abort
  call fuzzbox#Select(s:buffer_items(), {
        \ 'title': 'Buffers',
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'select_cb': function('s:select_buffer', ['default']),
        \ 'preview_cb': function('s:preview_buffer'),
        \ 'actions': s:buffer_actions(),
        \ })
endfunction

function! s:recent_items(dir) abort
  let l:dir = s:normalize_dir(a:dir)
  let l:seen = {}
  let l:paths = []
  for l:buf in getbufinfo({'buflisted': 1})
    if filereadable(l:buf.name)
      let l:path = fnamemodify(l:buf.name, ':p')
      let l:seen[l:path] = 1
      call add(l:paths, l:path)
    endif
  endfor
  for l:file in v:oldfiles
    let l:path = fnamemodify(l:file, ':p')
    if filereadable(l:path) && !has_key(l:seen, l:path)
      let l:seen[l:path] = 1
      call add(l:paths, l:path)
    endif
  endfor
  if !empty(l:dir)
    call filter(l:paths, 'stridx(v:val, l:dir) == 0')
  endif
  return map(l:paths, 'fnamemodify(v:val, ":~")')
endfunction

function! FuzzyRecent(...) abort
  let l:params = get(a:000, 0, {})
  call s:select_paths(s:recent_items(get(l:params, 'dir', '')), {
        \ 'title': 'Recent Files',
        \ 'cwd': '',
        \ })
endfunction

function! FuzzyHelpTags() abort
  execute 'FuzzyHelp'
endfunction

function! FuzzyCommandHistory() abort
  execute 'FuzzyCmdHistory'
endfunction

function! s:git_hash(result) abort
  return matchstr(a:result, '[a-f0-9]\{7,\}')
endfunction

function! s:preview_git(wid, result, opts) abort
  if a:wid == -1
    return
  endif
  let l:hash = s:git_hash(a:result)
  if empty(l:hash)
    call popup_settext(a:wid, ['No valid commit selected'])
    return
  endif

  let l:dir = get(a:opts, 'cwd', getcwd())
  let l:preview_args = get(a:opts, 'git_preview_args', '')
  let l:cmd = 'git -C ' . shellescape(l:dir) . ' show --color=never ' . l:preview_args . ' ' . shellescape(l:hash)
  call fuzzbox#popup#SetTitle(a:wid, l:hash)
  call popup_settext(a:wid, systemlist(l:cmd))
  call win_execute(a:wid, 'setlocal syntax=diff')
endfunction

function! s:git_noop(wid, result, opts) abort
endfunction

function! s:git_fixup(wid, result, opts) abort
  let l:hash = s:git_hash(a:result)
  if !empty(l:hash)
    silent! call popup_close(a:wid)
    let l:cmd = 'git commit --fixup=' . l:hash
    execute 'silent !' . l:cmd
    redraw!
    call EchoHi(l:cmd)
  endif
endfunction

function! s:git_autosquash(wid, result, opts) abort
  let l:hash = s:git_hash(a:result)
  if !empty(l:hash)
    silent! call popup_close(a:wid)
    let l:cmd = 'zsh -i -c ''git rebase -i --autosquash --autostash ' . l:hash . ';exec zsh'''
    execute 'silent !tmux splitw -v "' .  l:cmd . '"'
  endif
endfunction

function! s:git_actions() abort
  return {
        \ "\<c-f>": function('s:git_fixup'),
        \ "\<c-s>": function('s:git_autosquash'),
        \ }
endfunction

function! SearchGit(...) abort
  let l:params = get(a:000, 0, {})
  let l:source = get(l:params, 'source', 'git log')
  let l:dir = s:normalize_dir(get(l:params, 'dir', getcwd()))

  let l:git_log_format = get(l:params, 'format', '%h %>(12,trunc)%cr %d %s %an')
  let l:git_log_args = get(l:params, 'source_args', '--abbrev=7 --oneline --format=' . shellescape(l:git_log_format))
  if l:source ==# 'git log'
    let l:source = l:source . ' ' . l:git_log_args
  endif

  let l:items = s:run_lines(l:source, l:dir)
  call fuzzbox#Select(l:items, {
        \ 'title': 'Git',
        \ 'cwd': l:dir,
        \ 'preview': 1,
        \ 'compact': 0,
        \ 'async': 1,
        \ 'preview_cb': function('s:preview_git'),
        \ 'select_cb': function('s:git_noop'),
        \ 'actions': s:git_actions(),
        \ 'git_preview_args': get(l:params, 'preview_args', ''),
        \ })
endfunction
