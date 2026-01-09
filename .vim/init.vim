let g:vim_cache_dir = ($XDG_CACHE_HOME !=# '' ? $XDG_CACHE_HOME : expand('~/.cache')) . '/vim'
let s:bundle_dir = g:vim_cache_dir .. '/bundle'
let s:dein_dir = s:bundle_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_dir)
  if !executable('git') | echoerr 'missing git' | cquit | endif
  echomsg 'installing dein'
  call system('git clone https://github.com/Shougo/dein.vim.git ' . s:dein_dir)
endif

function! Missing(...) abort
  return join(filter(copy(a:000), {_, val -> !executable(val)}), ' ')
endfunction

set nocompatible

if has('vim_starting')
  execute 'set runtimepath^=' .. s:dein_dir
endif

call dein#begin(s:bundle_dir)
call dein#add('Shougo/dein.vim')
runtime! rc.plugins/*/*.rc.on.vim
call dein#end()

filetype plugin indent on

if dein#check_install() | call dein#install() | endif

runtime! rc.core/*.rc.on.vim
doautocmd User InitPost
