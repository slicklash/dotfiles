if !executable('vint')
  echo 'Error while processing ' . resolve(expand('<sfile>:p'))
  echo 'Error: missing vint executable from python3 package [vim-vint]'
  cquit
endif

" python3 import vint
call dein#add('syngan/vim-vimlint', { 'rev': 'cec40c28f119a5f4b92ceb0b6aae525122a81244' })
