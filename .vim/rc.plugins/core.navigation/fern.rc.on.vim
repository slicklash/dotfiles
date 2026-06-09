scriptencoding utf-8

call dein#add('lambdalisue/fern.vim', { 'rev': '3d580357c09e199b0fa7d560b2db1ad05de02b9c' })

let g:fern#default_hidden = 1
let g:fern#drawer_side = 'right'
let g:fern#drawer_keep = 1
let g:fern#disable_drawer_auto_restore = 0
let g:fern#disable_default_mappings = 1
let g:fern#disable_viewer_spinner = 1

let g:fern#renderer#default#root_symbol = '[in] '
let g:fern#renderer#default#leading = ' '
let g:fern#renderer#default#collapsed_symbol = '▸'
let g:fern#renderer#default#expanded_symbol  = '▾'
let g:fern#renderer#default#leaf_symbol = ''
let g:fern#renderer#default#indent_markers = 0

function! s:setup() abort
  nnoremap <silent> <space>v :call FernToggle()<CR>
endfunction

autocmd User InitPost ++once call s:setup()

function! s:fern_width() abort
  return exists('$TERMUX_VERSION') ? 25 : 50
endfunction

function! s:current_buffer_path() abort
  let l:path = expand('%:p')
  return empty(l:path) ? getcwd() : l:path
endfunction

function! s:current_buffer_dir() abort
  let l:path = s:current_buffer_path()
  return isdirectory(l:path) ? l:path : fnamemodify(l:path, ':p:h')
endfunction

function! s:resolve_fern_root(path) abort
  return isdirectory(a:path) ? a:path : fnamemodify(a:path, ':p:h')
endfunction

function! s:fern_cd(path) abort
  if empty(a:path)
    echoerr 'Register is empty'
    return
  endif

  let l:root = s:resolve_fern_root(a:path)
  execute 'Fern ' . fnameescape(l:root)
endfunction

function! FernToggle() abort
  execute printf(
        \ 'Fern %s -drawer -right -reveal=%s -toggle -width=%d',
        \ fnameescape(s:current_buffer_dir()),
        \ fnameescape(s:current_buffer_path()),
        \ s:fern_width())
endfunction

function! s:tmux_open_shell() abort
  let l:path = s:get_node_path()
  let l:cmd = isdirectory(l:path) ? l:path : fnamemodify(l:path, ':p:h')
  execute 'silent !tmux splitw -c ' . shellescape(l:cmd)
endfunction

function! s:tmux_open_code_agent(cli) abort
  if empty($TMUX) || empty($TMUX_PANE)
    echoerr 'Not inside tmux (TMUX/TMUX_PANE not set)'
    return
  endif

  let l:file = s:get_node_path()

  let l:newpane = system('tmux split-window -h -P -F "#{pane_id}"')
  let l:newpane = trim(l:newpane)

  if empty(l:newpane)
    echoerr 'tmux split-window failed'
    return
  endif

  call filter(getwininfo(), {i, v -> getbufvar(v.bufnr, '&filetype') ==# 'fern' ? execute(v.winnr . 'close') : 0})
  call system('tmux send-keys -t ' . shellescape(l:newpane) . ' ' . a:cli .'\ "' . shellescape(l:file) . '" C-m')
endfunction

function! s:get_node_path() abort
  let l:helper = fern#helper#new()
  let l:node = l:helper.sync.get_cursor_node()
  return l:node._path
endfunction

function! s:open_or_enter() abort
  let l:path = s:get_node_path()
  if isdirectory(l:path)
    call feedkeys("\<Plug>(fern-action-enter)", 'm')
    return
  endif

  call OpenPath('edit', l:path)
endfunction

function! s:preview_cursor(step) abort
  execute 'normal! ' . a:step
  let l:path = s:get_node_path()
  if isdirectory(l:path)
    return
  endif

  call OpenPath('edit_keep', l:path)
endfunction

function! s:search_target_dir() abort
  return s:resolve_fern_root(s:get_node_path()) . '/'
endfunction

function! s:search_pattern() abort
  call SearchIn(s:search_target_dir())
endfunction

function! s:search_yank() abort
  call SearchIn(s:search_target_dir(), @0)
endfunction

function! s:search_last() abort
  let l:pattern = substitute(@/, '^\\v', '', '')
  let l:pattern = substitute(l:pattern, '^\\<\(.\+\)\\>$', '\1', '')
  call SearchIn(s:search_target_dir(), l:pattern)
endfunction

function! s:search_files() abort
  call FuzzyFind({'dir': s:search_target_dir()})
endfunction

function! s:yank_to_register(reg) abort
  let l:path = s:get_node_path()
  if a:reg ==# '"'
    let l:cl = 'String'
  else
    let l:path = fnamemodify(l:path, ':p:h')
    let l:cl = 'Directory'
  endif
  call setreg(a:reg, l:path)
  call EchoHi('Yanked: ' . l:path)
endfunction

function! s:init_fern() abort
  setlocal nonumber
  setlocal norelativenumber
  setlocal signcolumn=yes

  nnoremap <buffer> ,k <Plug>(fern-action-leave)
  nnoremap <buffer><expr> j (line('.') == line('$') ? 'gg' : 'j')
  nnoremap <buffer><expr> k (line('.') == 1 ? 'G' : 'k')

  nnoremap <buffer><silent> y  :call <SID>yank_to_register('"')<CR>
  nnoremap <buffer><silent> yy :call <SID>yank_to_register('g')<CR>
  nnoremap <buffer><silent> yb :call <SID>yank_to_register('b')<CR>

  nnoremap <buffer> gh :<C-u>Fern ~/<CR>
  nnoremap <buffer><silent> gy :call <SID>fern_cd(getreg('g'))<CR>
  nnoremap <buffer><silent> gb :call <SID>fern_cd(getreg('b'))<CR>
  nnoremap <buffer> gv :<C-u>Fern ~/.vim<CR>
  nnoremap <buffer> gc :<C-u>Fern ~/code<CR>
  nnoremap <buffer> gt :<C-u>Fern ~/tmp<CR>
  nnoremap <buffer> gd :<C-u>Fern ~/Downloads<CR>
  nnoremap <buffer> ge :<C-u>Fern ~/Desktop<CR>
  nnoremap <buffer> gs :<C-u>Fern ~/Sync<CR>
  nnoremap <buffer> gw :<C-u>Fern ~/SyncWork<CR>

  nnoremap <buffer><silent> <CR> :call <SID>open_or_enter()<CR>

  nnoremap <buffer> E    <Plug>(fern-action-open:vsplit)
  nnoremap <buffer> x    <Plug>(fern-action-open:system)
  nnoremap <buffer><silent> J :call <SID>preview_cursor('j')<CR>
  nnoremap <buffer><silent> K :call <SID>preview_cursor('k')<CR>

  nnoremap <buffer> c  <Plug>(fern-action-clipboard-copy)
  nnoremap <buffer> m  <Plug>(fern-action-clipboard-move)
  nnoremap <buffer> p  <Plug>(fern-action-clipboard-paste)
  nnoremap <buffer> dd <Plug>(fern-action-remove)
  nnoremap <buffer> r  <Plug>(fern-action-rename)

  nnoremap <buffer> D <Plug>(fern-action-new-dir)
  nnoremap <buffer> N <Plug>(fern-action-new-file)

  nnoremap <buffer> h <Plug>(fern-action-collapse)
  nnoremap <buffer> H <Plug>(fern-action-collapse)
  nnoremap <buffer> l <Plug>(fern-action-open-or-expand)
  nnoremap <buffer> L <Plug>(fern-action-expand-tree:stay)

  nnoremap <buffer><silent> S :call <SID>tmux_open_shell()<Bar>redraw!<CR>
  nnoremap <buffer><silent> C :call <SID>tmux_open_code_agent('claude')<Bar>redraw!<CR>

  nnoremap <buffer> .    <Plug>(fern-action-hidden:toggle)
  nnoremap <buffer> <C-l> <Plug>(fern-action-reload)
  nnoremap <buffer> q    :<C-u>quit<CR>

  nnoremap <buffer> <Space> <Plug>(fern-action-mark:toggle)j
  nnoremap <buffer> *       <Plug>(fern-action-mark:toggle:all)

  nnoremap <buffer><silent> s :call <SID>search_pattern()<CR>
  nnoremap <buffer><silent> <C-y> :call <SID>search_yank()<CR>
  if has('win32')
    nnoremap <buffer><silent> <C-/> :call <SID>search_last()<CR>
  else
    nnoremap <buffer><silent> <C-_> :call <SID>search_last()<CR>
  endif
  nnoremap <buffer><silent> f :call <SID>search_files()<CR>
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
