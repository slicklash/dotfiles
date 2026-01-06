syntax enable

let mapleader = ","                         " change leader key
nnoremap <C-E> ,

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,latin1

set number                                  " show line number
set relativenumber                          " use relative numbers

augroup numbertoggle
  autocmd!
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup END

set history=1000

set timeoutlen=500 ttimeoutlen=30           " mapping and key code timeout
set ttyfast                                 " assume fast terminal connection
set updatetime=300
set lazyredraw                              " don't update screen while executing macros
set synmaxcol=200                           " faster

let g:vim_cache_dir = exists('$XDG_CACHE_HOME')
      \ ? $XDG_CACHE_HOME . '/vim'
      \ : expand('~/.vim/cache')

function! _ensure_path(path, ...)
  let is_file = a:0 > 0 && a:1 == 1 ? 1 : 0
  let path = resolve(expand(a:path))
  let dir = is_file ? fnamemodify(path, ':h') : path
  if !isdirectory(dir) | call mkdir(dir, 'p') | endif
  return path
endfunction

function! _cache_dir(path)
  return _ensure_path(g:vim_cache_dir . a:path)
endfunction

function! _cache_file(path)
  return _ensure_path(g:vim_cache_dir . a:path, 1)
endfunction

set guicursor=
set backupcopy=yes
set nobackup nowritebackup

let &directory = _cache_dir('/swap') . '//'
let &backupdir = _cache_dir('/bak')  . '//'
let &undodir   = _cache_dir('/undo') . '//'
set undofile

let $TMP=_ensure_path(g:vim_cache_dir . '/tmp')
