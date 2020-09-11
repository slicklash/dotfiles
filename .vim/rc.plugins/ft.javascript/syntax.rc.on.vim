if InitStep() == 0
  call dein#add('pangloss/vim-javascript', { 'on_ft' : ['javascript'] })
  call dein#add('maxmellon/vim-jsx-pretty', { 'on_ft' : ['jsx'] })
  finish
endif
