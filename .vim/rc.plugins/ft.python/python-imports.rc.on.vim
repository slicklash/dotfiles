if InitStep() == 0
  call dein#add('mgedmin/python-imports.vim', { 'on_ft': ['python'] })
  finish
endif
