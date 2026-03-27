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

highlight default ExtraWhitespace ctermbg=red guibg=red

function! s:clear_trailing_whitespace_match() abort
  if exists('w:extra_whitespace_match')
    call matchdelete(w:extra_whitespace_match)
    unlet w:extra_whitespace_match
  endif
endfunction

function! s:highlight_trailing_whitespace() abort
  if index(['diff', 'qf', 'gitcommit', 'defx', 'help'], &filetype) >= 0
    call s:clear_trailing_whitespace_match()
    return
  endif

  call s:clear_trailing_whitespace_match()
  let w:extra_whitespace_match = matchadd('ExtraWhitespace', '\s\+$')
endfunction

augroup trailing_whitespace
  autocmd!
  autocmd BufWinEnter,WinEnter,InsertLeave * call s:highlight_trailing_whitespace()
  autocmd FileType * call s:highlight_trailing_whitespace()
  autocmd WinLeave,BufWinLeave * call s:clear_trailing_whitespace_match()
augroup END

augroup indent_settings
  autocmd!
  autocmd FileType vim setlocal sw=2 sts=2 ts=2 et
  autocmd FileType make setlocal noexpandtab
augroup END
