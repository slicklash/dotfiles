vim9script

set list                                    # highlight whitespace
set listchars=tab:│\ ,trail:~,extends:>,precedes:<,nbsp:+
set backspace=indent,eol,start              # allow backspacing listed

set autoindent                              # use the current indent for new lines
set expandtab                               # insert spaces instead of tabs
set tabstop=4                               # number of spaces per tab for display
set softtabstop=4                           # number of spaces per tab in insert mode
set shiftwidth=4                            # number of spaces when indenting
set shiftround                              # round indent to sw
set nowrap                                  # don't wrap long lines

highlight default ExtraWhitespace ctermbg=red guibg=red

def ClearTrailingWhitespaceMatch()
  if exists('w:extra_whitespace_match')
    silent! matchdelete(w:extra_whitespace_match)
    unlet w:extra_whitespace_match
  endif
enddef

def HighlightTrailingWhitespace(pattern = '\s\+$')
  ClearTrailingWhitespaceMatch()
  if &buftype != '' || index(['diff', 'qf', 'gitcommit', 'fern', 'help'], &filetype) >= 0
    return
  endif
  w:extra_whitespace_match = matchadd('ExtraWhitespace', pattern)
enddef

def StripTrailingWhitespace()
  const view = winsaveview()
  keeppatterns :%s/\s\+$//e
  winrestview(view)
enddef

nnoremap <silent> <Leader>` <ScriptCmd>StripTrailingWhitespace()<CR>

augroup trailing_whitespace
  autocmd!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd BufWinEnter,WinEnter,InsertLeave,FileType * HighlightTrailingWhitespace()
  autocmd InsertEnter * HighlightTrailingWhitespace('\s\+\%#\@<!$')
  autocmd WinLeave,BufWinLeave * ClearTrailingWhitespaceMatch()
augroup END

augroup indent_settings
  autocmd!
  autocmd FileType vim setlocal sw=2 sts=2 ts=2 et
  autocmd FileType make setlocal noexpandtab
augroup END
