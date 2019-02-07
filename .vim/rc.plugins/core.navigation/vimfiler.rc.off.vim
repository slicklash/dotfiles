if InitStep() == 0
  if !has('lua')
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing +lua'
    cquit
  endif
  call dein#add('Shougo/vimfiler.vim')
  finish
elseif !dein#tap('unite.vim')
  finish
endif

set noautochdir
scriptencoding utf-8
let g:loaded_netrwPlugin = 1

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = '✗'
let g:vimfiler_marked_file_icon = '✓'
let g:vimfiler_ignore_pattern =
      \ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|.stversions\|.ropeproject\|.*\.js.map'
      \ .'\|node_modules\|.*\.pyc\|.*\.egg-info\|__pycache__\)$'

call vimfiler#custom#profile('default', 'context', {
      \ 'safe' : 0,
      \ 'auto_expand' : 0,
      \ 'parent' : 0,
      \ 'split': 1,
      \ 'quit': 0,
      \ 'explorer': 1,
      \ 'simple': 1,
      \ 'direction': 'rightbelow',
      \ 'split_action': 'left',
      \ 'preview_action': 'left',
      \ 'columns': 'type',
      \ 'winwidth': 50
      \ })

nnoremap <space>v :VimFiler -find<CR>
nnoremap <space>V :VimFilerBufferDir<CR>

augroup filetype_vimfiler
  autocmd!
  autocmd FileType vimfiler call s:init_vimfiler_settings()
augroup END

function! s:init_vimfiler_settings()
  nnoremap <silent><buffer><expr> t vimfiler#do_action('tabopen')
  nnoremap <silent><buffer><expr> s vimfiler#do_action('search')
  nnoremap <silent><buffer><expr> <C-y> vimfiler#do_action('search_yank')
  if has('win32')
    nnoremap <silent><buffer><expr> <C-/> vimfiler#do_action('search_last')
  else
    nnoremap <silent><buffer><expr> <C-_> vimfiler#do_action('search_last')
  endif
endfunction
