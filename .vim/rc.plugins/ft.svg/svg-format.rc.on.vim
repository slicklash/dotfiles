vim9script

if !executable('xmllint')
  echo 'Error: missing libxml2-utils package'
  cquit
endif

def FtSvg()
  setlocal noautoindent
  setlocal formatprg=xmllint\ --format\ -
enddef

augroup ft_svg
  autocmd!
  autocmd FileType svg FtSvg()
augroup END
