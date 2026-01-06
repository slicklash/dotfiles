if !executable('xmllint')
  echo 'Error: missing libxml2-utils package'
  cquit
endif

augroup ft_svg
  autocmd!
  autocmd FileType svg call s:ft_svg()
augroup END

function! s:ft_svg() abort
  setlocal noautoindent
  setlocal formatprg=xmllint\ --format\ -
endfunction
