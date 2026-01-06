if !executable('sqlformat')
  echo 'Error: missing python package [sqlparse]'
  cquit
endif

augroup ft_sql
  autocmd!
  autocmd FileType sql call s:ft_sql()
augroup END

function! s:ft_sql() abort
  setlocal noautoindent
  setlocal formatprg=sqlformat\ --reindent\ --keywords\ upper\ --identifiers\ lower\ -
endfunction
