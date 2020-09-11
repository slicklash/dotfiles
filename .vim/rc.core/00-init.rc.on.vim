if &compatible
    set nocompatible
endif

let mapleader = ","                         " change leader key
nnoremap <C-E> ,

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,latin1

set number                                  " show line number
set relativenumber                          " use relative numbers

if &history < 1000
  set history=1000
endif

set timeoutlen=500 ttimeoutlen=30           " mapping and key code timeout
set ttyfast                                 " assume fast terminal connection
set lazyredraw                              " don't update screen while executing macros
set synmaxcol=200                           " faster syntax highlight

let g:vim_dir = '~/.vim'

function! _ensure_path(path, ...)
    let l:is_file = a:0 > 0 && a:1 == 1 ? 1 : 0
    let l:path = resolve(expand(a:path))
    let l:dir = l:is_file ? fnamemodify(l:path, ':h') : l:path
    if !isdirectory(l:dir) | call mkdir(l:dir, 'p') | endif
    return l:path
endfunction

function! _cache_dir(path)
    return _ensure_path(g:vim_dir . '/cache/' . a:path)
endfunction

function! _cache_file(path)
    return _ensure_path(g:vim_dir . '/cache/' . a:path, 1)
endfunction

let &directory=_cache_dir('swap')
let &backupdir=_cache_dir('bak')

let $TMP=_ensure_path(g:vim_dir . '/tmp')
