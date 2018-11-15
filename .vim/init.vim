let s:BUNDLE_DIR = $HOME . '/.vim/bundle'
let s:DEIN_DIR= s:BUNDLE_DIR . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:DEIN_DIR)
    if !executable('git')
      echoerr 'missing git'
      cquit
    endif
    echomsg 'installing dein'
    echomsg 'cloning https://github.com/Shougo/dein.vim.git into ' . s:DEIN_DIR . '...'
    call system('git clone https://github.com/Shougo/dein.vim.git ' . s:DEIN_DIR)
endif

let s:is_windows = has('win32') || has('win64')

function! IsWindows()
    return s:is_windows
endfunction

filetype off

if &compatible
    set nocompatible
endif

if has('vim_starting')
    set all&
    set runtimepath+=~/.vim
    set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim
endif

function! InitStep()
  return s:init_step
endfunction

function! _init(step)
    let s:init_step = a:step
    if a:step == 0
        runtime! rc.plugins/*/*.rc.on.vim
    elseif a:step == 1
        runtime! rc.core/*.rc.on.vim
    else
        runtime! rc.plugins/*/*.rc.on.vim
    endif
endfunction

call dein#begin(s:BUNDLE_DIR)
    call dein#add('Shougo/dein.vim')
    call _init(0)
call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install() | call dein#install() | endif

call _init(1)
call _init(2)

set guicursor=
set backupcopy=yes
set nobackup nowritebackup
