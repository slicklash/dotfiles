vim9script

if !executable('sqlformat')
  echo 'Error: missing python package [sqlparse]'
  cquit
endif

def FtSql()
  setlocal noautoindent
  setlocal formatprg=sqlformat\ --reindent\ --keywords\ upper\ --identifiers\ lower\ -
enddef

augroup ft_sql
  autocmd!
  autocmd FileType sql FtSql()
augroup END
