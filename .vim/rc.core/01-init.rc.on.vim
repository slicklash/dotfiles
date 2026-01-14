syntax enable

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,latin1
set fileformats=unix,dos,mac

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

set noerrorbells novisualbell t_vb=         " disable sounds"
set shortmess+=atI                          " avoid some hit-enter prompts

set hidden

set mouse=a                                 " enable mouse in all modes
set mousemodel=extend

set modelines=0
set foldenable                              " enable folds by default
set foldlevelstart=99                       " open all folds by default
set foldmethod=manual

set scrolloff=3
set sidescrolloff=5

set splitbelow                              " put the new window below the current
set splitright                              " put the new window on the right of the current

set diffopt+=algorithm:patience,inline:char " improved diff
set diffopt+=indent-heuristic

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

let &directory = _cache_dir('/swap') . '//'
let &backupdir = _cache_dir('/bak')  . '//'
let &undodir   = _cache_dir('/undo') . '//'
let $TMP=_ensure_path(g:vim_cache_dir . '/tmp')

set backupcopy=yes
set nobackup nowritebackup
set undofile

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal keywordprg=:help sw=2
  autocmd FileType vim if @% =~ '.vim/rc' | setlocal foldmethod=marker foldlevel=0 | else | setlocal foldmethod=indent | endif
augroup END
