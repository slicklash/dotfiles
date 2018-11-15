if InitStep() == 0
  call dein#add('pangloss/vim-javascript', { 'on_ft' : ['javascript'] })
  call dein#add('mxw/vim-jsx', { 'on_ft' : ['javascript', 'jsx'] })
  finish
endif
