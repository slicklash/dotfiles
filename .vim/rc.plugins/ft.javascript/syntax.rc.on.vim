if InitStep() == 0
  call dein#add('pangloss/vim-javascript', { 'on_ft' : ['javascript', 'typescript'] })
  call dein#add('maxmellon/vim-jsx-pretty', { 'on_ft' : ['jsx', 'tsx'] })
  finish
endif
