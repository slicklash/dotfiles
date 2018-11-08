
set noerrorbells novisualbell t_vb=         " disable sounds"
set shortmess=atI                           " avoid some hit-enter prompts

set hidden
set nobackup                                " no backups

set mouse=a                                 " enable mouse in all modes

set modelines=0
set foldenable                              " enable folds by default
set foldlevelstart=99                       " open all folds by default

set scrolloff=1 scrolljump=5                " scroll content when cursor reaches end of screen

set splitbelow                              " put the new window below the current
set splitright                              " put the new window on the right of the current

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal keywordprg=:help sw=2
    autocmd FileType vim if @% =~ 'vimrc' | setlocal foldmethod=marker foldlevel=0 | else | setlocal foldmethod=indent | endif
augroup END

autocmd FileType qf wincmd J                " move quickfix window to bottom
