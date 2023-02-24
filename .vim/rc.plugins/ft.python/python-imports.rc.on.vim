if InitStep() == 0
  call dein#add('mgedmin/python-imports.vim', { 'rev': 'b33323aa8c21cf93b115ccbf85e6958b351b410d', 'on_ft': ['python'] })
  finish
endif
