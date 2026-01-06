set noerrorbells novisualbell t_vb=         " disable sounds"
set shortmess+=atI                           " avoid some hit-enter prompts

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

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal keywordprg=:help sw=2
  autocmd FileType vim if @% =~ 'vimrc' | setlocal foldmethod=marker foldlevel=0 | else | setlocal foldmethod=indent | endif
augroup END

" move to bottom
augroup special_windows
  autocmd!
  autocmd FileType qf,fugitive wincmd J
augroup END
