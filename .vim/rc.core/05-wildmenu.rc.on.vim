" Command-line completion (wildmenu)
set wildmenu
set wildmode=longest:full,full
set wildignorecase
set wildoptions=pum
set showcmd

" Ignore noisy files and directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/node_modules/*,*/dist/*,*/build/*
set wildignore+=*/__pycache__/*,*.pyc,*.pyo
set wildignore+=*.o,*.obj,*.so,*.dll
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.7z
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.svg
set wildignore+=*/.idea/*,*/.vscode/*

" Recursive path completion
set path+=**
