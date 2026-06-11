vim9script
scriptencoding utf-8

dein#add('lambdalisue/fern.vim', {'rev': '3d580357c09e199b0fa7d560b2db1ad05de02b9c'})

g:fern#default_hidden = 1
g:fern#drawer_side = 'right'
g:fern#drawer_keep = 1
g:fern#disable_drawer_auto_restore = 0
g:fern#disable_default_mappings = 1
g:fern#disable_viewer_spinner = 1

g:fern#renderer#default#root_symbol = '[in] '
g:fern#renderer#default#leading = ' '
g:fern#renderer#default#collapsed_symbol = '▸'
g:fern#renderer#default#expanded_symbol = '▾'
g:fern#renderer#default#leaf_symbol = ''
g:fern#renderer#default#indent_markers = 0

def GetFernWidth(): number
  return exists('$TERMUX_VERSION') ? 25 : 50
enddef

def GetCurrentBufferPath(): string
  var path = expand('%:p')
  return empty(path) ? getcwd() : path
enddef

def GetCurrentBufferDir(): string
  var path = GetCurrentBufferPath()
  return isdirectory(path) ? path : fnamemodify(path, ':p:h')
enddef

def ResolveFernRoot(path: string): string
  return isdirectory(path) ? path : fnamemodify(path, ':p:h')
enddef

def FernCd(path: string)
  if empty(path)
    echoerr 'Register is empty'
    return
  endif
  var root = ResolveFernRoot(path)
  execute 'Fern ' .. fnameescape(root)
enddef

def g:FernToggle()
  execute printf(
        \ 'Fern %s -drawer -right -reveal=%s -toggle -width=%d',
        \ fnameescape(GetCurrentBufferDir()),
        \ fnameescape(GetCurrentBufferPath()),
        \ GetFernWidth())
enddef

def GetNodePath(): string
  var helper = fern#helper#new()
  var node = helper.sync.get_cursor_node()
  return node._path
enddef

def TmuxOpenShell()
  var path = GetNodePath()
  var cmd = isdirectory(path) ? path : fnamemodify(path, ':p:h')
  execute 'silent !tmux splitw -c ' .. shellescape(cmd)
enddef

def TmuxOpenCodeAgent(cli: string)
  if empty($TMUX) || empty($TMUX_PANE)
    echoerr 'Not inside tmux (TMUX/TMUX_PANE not set)'
    return
  endif

  var file = GetNodePath()
  var newpane = trim(system('tmux split-window -h -P -F "#{pane_id}"'))

  if empty(newpane)
    echoerr 'tmux split-window failed'
    return
  endif

  for w in getwininfo()
    if getbufvar(w.bufnr, '&filetype') ==# 'fern'
      execute w.winnr .. 'close'
    endif
  endfor
  system('tmux send-keys -t ' .. shellescape(newpane) .. ' ' .. cli .. '\ "' .. shellescape(file) .. '" C-m')
enddef

def OpenOrEnter()
  var path = GetNodePath()
  if isdirectory(path)
    feedkeys("\<Plug>(fern-action-enter)", 'm')
    return
  endif

  g:OpenPath('edit', path)
enddef

def PreviewCursor(step: string)
  execute 'normal! ' .. step
  var path = GetNodePath()
  if isdirectory(path)
    return
  endif

  g:OpenPath('edit_keep', path)
enddef

def GetSearchTargetDir(): string
  return ResolveFernRoot(GetNodePath()) .. '/'
enddef

def SearchPattern()
  g:SearchIn(GetSearchTargetDir())
enddef

def SearchYank()
  g:SearchIn(GetSearchTargetDir(), @0)
enddef

def SearchLast()
  var pattern = substitute(@/, '^\\v', '', '')
  pattern = substitute(pattern, '^\\<\(.\+\)\\>$', '\1', '')
  g:SearchIn(GetSearchTargetDir(), pattern)
enddef

def SearchFiles()
  g:FuzzyFind({'dir': GetSearchTargetDir()})
enddef

def YankToRegister(reg: string)
  var path = GetNodePath()
  var cl: string
  if reg ==# '"'
    cl = 'String'
  else
    path = fnamemodify(path, ':p:h')
    cl = 'Directory'
  endif
  setreg(reg, path)
  g:EchoHi('Yanked: ' .. path)
enddef

def InitFern()
  setlocal nonumber
  setlocal norelativenumber
  setlocal signcolumn=yes

  nnoremap <buffer> ,k <Plug>(fern-action-leave)
  nnoremap <buffer><expr> j (line('.') == line('$') ? 'gg' : 'j')
  nnoremap <buffer><expr> k (line('.') == 1 ? 'G' : 'k')

  nnoremap <buffer><silent> y  :call <SID>YankToRegister('"')<CR>
  nnoremap <buffer><silent> yy :call <SID>YankToRegister('g')<CR>
  nnoremap <buffer><silent> yb :call <SID>YankToRegister('b')<CR>

  nnoremap <buffer> gh :<C-u>Fern ~/<CR>
  nnoremap <buffer><silent> gy :call <SID>FernCd(getreg('g'))<CR>
  nnoremap <buffer><silent> gb :call <SID>FernCd(getreg('b'))<CR>
  nnoremap <buffer> gv :<C-u>Fern ~/.vim<CR>
  nnoremap <buffer> gc :<C-u>Fern ~/code<CR>
  nnoremap <buffer> gt :<C-u>Fern ~/tmp<CR>
  nnoremap <buffer> gd :<C-u>Fern ~/Downloads<CR>
  nnoremap <buffer> ge :<C-u>Fern ~/Desktop<CR>
  nnoremap <buffer> gs :<C-u>Fern ~/Sync<CR>
  nnoremap <buffer> gw :<C-u>Fern ~/SyncWork<CR>

  nnoremap <buffer><silent> <CR> :call <SID>OpenOrEnter()<CR>

  nnoremap <buffer> E    <Plug>(fern-action-open:vsplit)
  nnoremap <buffer> x    <Plug>(fern-action-open:system)
  nnoremap <buffer><silent> J :call <SID>PreviewCursor('j')<CR>
  nnoremap <buffer><silent> K :call <SID>PreviewCursor('k')<CR>

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

  nnoremap <buffer><silent> S :call <SID>TmuxOpenShell()<Bar>redraw!<CR>
  nnoremap <buffer><silent> C :call <SID>TmuxOpenCodeAgent('claude')<Bar>redraw!<CR>

  nnoremap <buffer> .    <Plug>(fern-action-hidden:toggle)
  nnoremap <buffer> <C-l> <Plug>(fern-action-reload)
  nnoremap <buffer> q    :<C-u>quit<CR>

  nnoremap <buffer> <Space> <Plug>(fern-action-mark:toggle)j
  nnoremap <buffer> *       <Plug>(fern-action-mark:toggle:all)

  nnoremap <buffer><silent> s :call <SID>SearchPattern()<CR>
  nnoremap <buffer><silent> <C-y> :call <SID>SearchYank()<CR>
  if has('win32')
    nnoremap <buffer><silent> <C-/> :call <SID>SearchLast()<CR>
  else
    nnoremap <buffer><silent> <C-_> :call <SID>SearchLast()<CR>
  endif
  nnoremap <buffer><silent> f :call <SID>SearchFiles()<CR>
enddef

def Setup()
  nnoremap <silent> <space>v :call FernToggle()<CR>
enddef

autocmd User InitPost ++once Setup()

augroup fern-custom
  autocmd! *
  autocmd FileType fern InitFern()
augroup END
