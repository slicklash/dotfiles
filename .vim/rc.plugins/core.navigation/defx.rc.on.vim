scriptencoding utf-8

if !has('python3')
  echo 'Error while processing ' . resolve(expand('<sfile>:p'))
  echo 'Error: missing +python3'
  cquit
endif

try
  python3 import pynvim
catch
  echo 'Error while processing ' . resolve(expand('<sfile>:p'))
  echo 'Error: missing python3 package [pynvim]'
  cquit
endtry

call dein#add('Shougo/defx.nvim', { 'rev': '1b17dc334294ef0da74ffa5a05d425ffcaf39a3f' })
if !has('nvim') && !dein#tap('nvim-yarp')
  call dein#add('roxma/nvim-yarp', { 'rev': 'bb5f5e038bfe119d3b777845a76b0b919b35ebc8' })
  call dein#add('roxma/vim-hug-neovim-rpc', { 'rev': '93ae38792bc197c3bdffa2716ae493c67a5e7957' })
endif

function! s:setup() abort
  call defx#custom#column('icon', {
        \ 'directory_icon': '▸',
        \ 'opened_icon': '▾',
        \ 'root_icon': ' ',
        \ })

  call defx#custom#column('mark', {
        \ 'readonly_icon': '✗',
        \ 'selected_icon': '✓',
        \ })

  if !exists('$TERMUX_VERSION')
    nnoremap <space>v :Defx `expand('%:p:h')` -ignored-files='__pycache__,.*' -split=vertical -winwidth=50 -search=`expand('%:p')`<CR>
  else
    nnoremap <space>v :Defx `expand('%:p:h')` -ignored-files='__pycache__,.*' -split=vertical -winwidth=25 -search=`expand('%:p')`<CR>
  endif
endfunction

autocmd User InitPost ++once call s:setup()

function! SearchPattern(context) abort
  let dir = a:context.targets[0] . '/'
  call SearchIn(dir)
endfunction

function! SearchYank(context) abort
  let dir = a:context.targets[0] . '/'
  call SearchIn(dir, @0)
endfunction

function! SearchLast(context) abort
  let dir = a:context.targets[0] . '/'
  let pattern = substitute(@/, '^\\v', '', '')
  let pattern = substitute(pattern, '^\\<\(.\+\)\\>$', '\1', '')
  call SearchIn(dir, pattern)
endfunction

function! SearchFiles(context) abort
  let dir = a:context.targets[0] . '/'
  call _fzf({'dir': dir})
endfunction

command! -nargs=* -range MyDefxOpen call OpenPath('edit', <q-args>)
command! -nargs=* -range MyDefxPreview call OpenPath('edit_keep', <q-args>)
command! -nargs=* -range MyDefxVsplit call OpenPath('vsplit', <q-args>)

function! s:tmux_open_shell() abort
  let cmd = fnamemodify(get(defx#get_candidate(), 'action__path'), ':p:h')
  execute 'silent !tmux splitw -c ' . cmd
endfunction

function! s:tmux_open_codex() abort
  if empty($TMUX) || empty($TMUX_PANE)
    echoerr 'Not inside tmux (TMUX/TMUX_PANE not set)'
    return
  endif

  let l:file = get(defx#get_candidate(), 'action__path')

  let l:cwd = expand('%:p')
  let l:newpane = system('tmux split-window -h -P -F "#{pane_id}"')
  let l:newpane = trim(l:newpane)

  if empty(l:newpane)
    echoerr 'tmux split-window failed'
    return
  endif

  call filter(getwininfo(), {i, v -> getbufvar(v.bufnr, '&filetype') ==# 'defx' ? execute(v.winnr . 'close') : 0})
  call system('tmux send-keys -t ' . shellescape(l:newpane) . ' ' . shellescape('codex ' . l:file) . ' C-m')
endfunction

function! s:yank_to_register(reg) abort
  if a:reg ==# '"'
    let l:path = get(defx#get_candidate(), 'action__path')
    let l:cl = 'String'
  else
    let l:path = fnamemodify(get(defx#get_candidate(), 'action__path'), ':p:h')
    let l:cl = 'Directory'
  endif
  call setreg(a:reg, l:path)
  call EchoHi('Yanked: ' . l:path, l:cl)
endfunction

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> ,k defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'

  nnoremap <silent><buffer> y  <cmd>call <SID>yank_to_register('"')<CR>
  nnoremap <silent><buffer> yy <cmd>call <SID>yank_to_register('g')<CR>

  nnoremap <silent><buffer><expr> gh defx#do_action('cd')
  nnoremap <silent><buffer><expr> gy defx#do_action('cd', [fnameescape(getreg('g'))])
  nnoremap <silent><buffer><expr> gv defx#do_action('cd', [expand('~/.vim')])
  nnoremap <silent><buffer><expr> gc defx#do_action('cd', [expand('~/code')])
  nnoremap <silent><buffer><expr> gd defx#do_action('cd', [expand('~/Downloads')])
  nnoremap <silent><buffer><expr> ge defx#do_action('cd', [expand('~/Desktop')])
  nnoremap <silent><buffer><expr> gs defx#do_action('cd', [expand('~/Sync')])
  nnoremap <silent><buffer><expr> gw defx#do_action('cd', [expand('~/SyncWork')])

  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')

  nnoremap <silent><buffer><expr> <CR> defx#do_action('open', 'MyDefxOpen')
  nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')

  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> m defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> dd defx#do_action('remove')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')

  nnoremap <silent><buffer><expr> h defx#do_action('close_tree')
  nnoremap <silent><buffer><expr> H defx#do_action('close_tree')
  nnoremap <silent><buffer><expr> l defx#do_action('open_tree')
  nnoremap <silent><buffer><expr> L defx#do_action('open_tree', 'recursive:5')
  nnoremap <silent><buffer><expr> E defx#do_action('open', 'MyDefxVsplit')
  nnoremap <silent><buffer><expr> J 'j' . defx#do_action('open', 'MyDefxPreview')
  nnoremap <silent><buffer><expr> K 'k' . defx#do_action('open', 'MyDefxPreview')

  nnoremap <silent><buffer><expr> D defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')

  nnoremap <silent><buffer> S <cmd>call <SID>tmux_open_shell()<Bar>redraw!<CR>
  nnoremap <silent><buffer> C <cmd>call <SID>tmux_open_codex()<CR>

  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')

  nnoremap <silent><buffer><expr> ; defx#do_action('repeat')

  nnoremap <silent><buffer><expr> q defx#do_action('quit')

  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')

  nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
  nnoremap <silent><buffer><expr> s defx#do_action('call', 'SearchPattern')
  nnoremap <silent><buffer><expr> <C-y> defx#do_action('call', 'SearchYank')
  if has('win32')
    nnoremap <silent><buffer><expr> <C-/> defx#do_action('call', 'SearchLast')
  else
    nnoremap <silent><buffer><expr> <C-_> defx#do_action('call', 'SearchLast')
  endif
  nnoremap <silent><buffer><expr> f defx#do_action('call', 'SearchFiles')

endfunction
