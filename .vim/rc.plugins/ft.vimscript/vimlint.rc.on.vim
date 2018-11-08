if InitStep() == 0
    call dein#add('syngan/vim-vimlint')
    finish
endif

if !executable('vint')
  echoerr 'missing vim-vint pacakge'
endif
