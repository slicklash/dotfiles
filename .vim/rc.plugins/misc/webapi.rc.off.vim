if InitStep() == 0
  call dein#add('mattn/webapi-vim', { 'on_ft': ['vim'] })
  finish
endif
