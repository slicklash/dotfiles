vim9script

syntax enable

# change leader key
g:mapleader = ","
nnoremap <C-E> ,

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,latin1
set fileformats=unix,dos,mac

set number                                  # show line number
set relativenumber                          # use relative numbers

augroup numbertoggle
  autocmd!
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup END

set history=1000

set timeoutlen=500 ttimeoutlen=30           # mapping and key code timeout
set ttyfast                                 # assume fast terminal connection
set updatetime=300
set lazyredraw                              # don't update screen while executing macros
set synmaxcol=200                           # faster

set noerrorbells novisualbell t_vb=         # disable sounds
set shortmess+=atI                          # avoid some hit-enter prompts

set hidden

set mouse=a                                 # enable mouse in all modes
set mousemodel=extend

set modelines=0
set foldenable                              # enable folds by default
set foldlevelstart=99                       # open all folds by default
set foldmethod=manual

set scrolloff=3
set sidescrolloff=5

set splitbelow                              # put the new window below the current
set splitright                              # put the new window on the right of the current

set diffopt+=algorithm:patience,inline:char # improved diff
set diffopt+=indent-heuristic

def MakePath(path: string, ...rest: list<any>): string
  var is_file = len(rest) > 0 && rest[0] == 1
  var resolved = resolve(expand(path))
  var dir = is_file ? fnamemodify(resolved, ':h') : resolved
  if !isdirectory(dir)
    mkdir(dir, 'p')
  endif
  return resolved
enddef

def g:MakeCacheDir(path: string): string
  return MakePath(g:vim_cache_dir .. path)
enddef

def g:MakeCacheFile(path: string): string
  return MakePath(g:vim_cache_dir .. path, 1)
enddef

&directory = g:MakeCacheDir('/swap') .. '//'
&backupdir = g:MakeCacheDir('/bak') .. '//'
&undodir = g:MakeCacheDir('/undo') .. '//'
$TMP = MakePath(g:vim_cache_dir .. '/tmp')

set backupcopy=yes
set nobackup nowritebackup
set undofile

def SetVimFolding()
  if @% =~ '.vim/rc'
    setlocal foldmethod=marker foldlevel=0
  else
    setlocal foldmethod=indent
  endif
enddef

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal keywordprg=:help sw=2
  autocmd FileType vim SetVimFolding()
augroup END
