set list                                    " highlight whitespace
set listchars=tab:│\ ,trail:~,extends:>,precedes:<,nbsp:+
set backspace=indent,eol,start              " allow backspacing listed

set autoindent                              " use the current indent for new lines
set expandtab                               " insert spaces instead of tabs
set tabstop=4                               " number of spaces per tab for display
set softtabstop=4                           " number of spaces per tab in insert mode
set shiftwidth=4                            " number of spaces when indenting
set shiftround                              " round indent to sw
set nowrap                                  " don't wrap long lines

augroup indent_settings
  autocmd!
  autocmd FileType vim setlocal sw=2 sts=2 ts=2 et
  autocmd FileType make setlocal noexpandtab
augroup END
