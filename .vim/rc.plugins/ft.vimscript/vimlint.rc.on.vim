if InitStep() == 0
  if !executable('vint')
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing vint'
    cquit
  endif
  try
    python3 import vint
  catch
    echo 'Error while processing ' . resolve(expand('<sfile>:p'))
    echo 'Error: missing python3 pacakge [vim-vint]'
    cquit
  endtry
  call dein#add('syngan/vim-vimlint')
  finish
endif

