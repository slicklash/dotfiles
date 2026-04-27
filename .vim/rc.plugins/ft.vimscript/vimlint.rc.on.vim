if !executable('vint')
  echo 'Error while processing ' . resolve(expand('<sfile>:p'))
  echo 'Error: missing vint executable from python3 package [vim-vint]'
  cquit
endif
