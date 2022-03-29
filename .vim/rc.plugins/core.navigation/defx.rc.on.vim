scriptencoding utf-8

if InitStep() == 0
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
  call dein#add('Shougo/defx.nvim', { 'rev': '8e53802a2691f8629ae08aca970595b6522aca46' })
  if !has('nvim') && !dein#tap('nvim-yarp')
    call dein#add('roxma/nvim-yarp', { 'rev': 'b710bf4daccb603a423754794fb446e5fbb59576' })
    call dein#add('roxma/vim-hug-neovim-rpc', { 'rev': '93ae38792bc197c3bdffa2716ae493c67a5e7957' })
  endif
  finish
endif

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

" let g:vimfiler_ignore_pattern =
      " \ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|.stversions\|.ropeproject\|.*\.js.map'
      " \ .'\|node_modules\|.*\.pyc\|.*\.egg-info\|__pycache__\)$'

nnoremap <space>V :Defx -split=vertical -winwidth=50<CR>
nnoremap <space>v :Defx `expand('%:p:h')` -split=vertical -winwidth=50 -search=`expand('%:p')`<CR>

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
command! -nargs=* -range MyDefxVsplit call OpenPath('vsplit', <q-args>)
command! -nargs=* -range MyDefxPsplit call OpenPath('psplit', <q-args>)

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> s defx#do_action('call', 'SearchPattern')
  nnoremap <silent><buffer><expr> <C-y> defx#do_action('call', 'SearchYank')
  if has('win32')
    nnoremap <silent><buffer><expr> <C-/> defx#do_action('call', 'SearchLast')
  else
    nnoremap <silent><buffer><expr> <C-_> defx#do_action('call', 'SearchLast')
  endif
  nnoremap <silent><buffer><expr> f defx#do_action('call', 'SearchFiles')
  nnoremap <silent><buffer><expr> <CR> defx#do_action('open', 'MyDefxOpen')
  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> m defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> h defx#do_action('close_tree')
  nnoremap <silent><buffer><expr> l defx#do_action('open_tree')
  nnoremap <silent><buffer><expr> E defx#do_action('open', 'MyDefxVsplit')
  nnoremap <silent><buffer><expr> P defx#do_action('open', 'MyDefxPsplit')
  nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
  " nnoremap <silent><buffer><expr> C defx#do_action('toggle_columns', 'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> dd defx#do_action('remove')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')
  nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
  nnoremap <silent><buffer><expr> ,k defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
endfunction
